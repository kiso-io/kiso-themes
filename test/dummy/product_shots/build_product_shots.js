const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');
const rimraf = require('rimraf-promise');
const mkdirp = require('mkdirp-promise');
const sharp = require('sharp');
const kue = require('kue');
const ip = require('ip');

var RENDER_JOBS = kue.createQueue();
var renderJobCount = 0;


function getHostIp() {
  return ip.address();
}

const HOST=`${getHostIp()}:4000`

async function screenshotDOMElement(page, opts = {}) {
  const padding = 'padding' in opts ? opts.padding : 0;
  const path = 'path' in opts ? opts.path : null;
  const selector = opts.selector;
  const fullScreen = opts.fullScreen

  if (!selector)
    throw Error('Please provide a selector.');

  const rect = await page.evaluate(selector => {
    const element = document.querySelector(selector);
    if (!element)
      return null;

    const {x, y, width, height} = element.getBoundingClientRect();

    const style = window.getComputedStyle(element);
    const margin = parseFloat(style.marginLeft) + parseFloat(style.marginRight),
    padding = parseFloat(style.paddingLeft) + parseFloat(style.paddingRight),
    border = parseFloat(style.borderLeftWidth) + parseFloat(style.borderRightWidth);


    return {
      left: x + parseFloat(style.paddingLeft),
      top: y + parseFloat(style.paddingTop),
      width: width - parseFloat(style.paddingLeft),
      height,
      id: element.id
    };
  }, selector);

  if (!rect)
    throw Error(`Could not find element that matches selector: ${selector}.`);

  let shotOpts = {
    type: 'jpeg'
  }
  shotOpts.path = path

  if(fullScreen) {
    shotOpts.fullPage = true
  } else {
    shotOpts.clip = {
      x: rect.left - padding,
      y: rect.top - padding,
      width: rect.width + padding * 2,
      height: rect.height + padding * 2
    }
  }

  return await page.screenshot(shotOpts);
}

async function snapshotElement(page, url, selector, displayTitle, outputPath, fileName) {
  var targetUrl = `http://${HOST}/` + url;

  await page.goto(targetUrl, { waitUntil: 'networkidle2' });
  await page.evaluate("$(window).off('resize'); $('.nav-side-container').slimScroll({destroy: true}); $('.nav-side-container').css('overflow', 'visible').css('height', '100%'); $('.inspect-mode').remove()")

  const filePath = path.join(outputPath, fileName+'_source.jpg');
  await screenshotDOMElement(page, {
    path: filePath,
    selector: selector,
    fullScreen: true,
    padding: 0
  });
}

async function generateHeroShots(theme, style, outputPath) {
  var targetUrls = [
    `preview/001_dashboards@ti-dashboard/001_dashboard_1`,
    `preview/001_dashboards@ti-dashboard/002_dashboard_2`,
    `preview/001_dashboards@ti-dashboard/003_dashboard_3`,
    `preview/001_dashboards@ti-dashboard/004_dashboard_4`,
  ];

  for(var counter=0; counter < targetUrls.length; counter++) {
    var themeString = `?theme=${theme}&style=${style}`

    await createRenderJob( theme, style, targetUrls[counter]+themeString, 'body', 'hero_shot', outputPath, `hero_shot_${counter+1}`, {
      inputFile: path.join(outputPath, `hero_shot_${counter+1}_source.jpg`),
      stack: {
        [path.join(outputPath, `hero_shot_${counter+1}@2x.jpg`)]: {
          resizeX: 2800,
          resizeY: 920,
          crop: sharp.gravity.north
        },
        [path.join(outputPath, `hero_shot_${counter+1}.jpg`)]:{
          resizeX: 1400,
          resizeY: 460,
          crop: sharp.gravity.north
        },
        [path.join(outputPath, `shot_${counter+1}@2x.jpg`)]:{
          resizeX: 760,
          resizeY: 356,
          crop: sharp.gravity.north
        },
        [path.join(outputPath, `shot_${counter+1}.jpg`)]:{
          resizeX: 380,
          resizeY: 178,
          crop: sharp.gravity.north
        }
      }
    })
  }
}

async function createRenderJob(theme, style, url, selector, displayTitle, outputPath, fileName, resizeStack) {
  var job = RENDER_JOBS.create('renderjob', {
    theme: theme,
    style: style,
    targetUrl: url,
    selector: selector,
    displayTitle: displayTitle,
    title: displayTitle,
    outputPath: outputPath,
    fileName: fileName,
    resizeStack: resizeStack
  }).attempts(3).removeOnComplete( true )

  job.on('complete',  function(result) {
    console.log(`[ COMPLETING ] ${renderJobCount} jobs remaining...`)

    if( renderJobCount === 0 ) {
      console.log("Shutting down...")
      process.exit();
    }
  }).on('failed', function(errorMessage){
    console.log('Job failed: ', errorMessage);
  })

  job.save()

  renderJobCount += 1;
}

async function resizeJob(resizeStack) {
  var keys = Object.keys(resizeStack.stack)

  for(outputFile of keys) {
    await sharp(resizeStack.inputFile)
    .resize(resizeStack.stack[outputFile].resizeX, resizeStack.stack[outputFile].resizeY)
    .crop(resizeStack.stack[outputFile].crop)
    .toFile( outputFile )
  }

  fs.unlinkSync( resizeStack.inputFile )
}

async function processMapping(obj, theme, style, parentName = '') {
  for(let key of Object.keys(obj)) {
    if( obj[key].hasOwnProperty('preview_url')) {
      let previewUrl = 'preview/' + obj[key].preview_url;
      let selector = obj[key].snapshot_selector;
      let displayTitle = obj[key].display_title;
      let outputPath = path.join(__dirname, 'shots', theme, style)
      let fileName = parentName + "_" + displayTitle.replace(/[\s]+/gi, "_").replace(/;/,"").toLowerCase();
      let filePath = path.join(outputPath, fileName+"_source.jpg")

      var themeString = `?theme=${theme}&style=${style}`

      await createRenderJob( theme, style, previewUrl+themeString, selector, displayTitle, outputPath, fileName, {
        inputFile: filePath,
        stack: {
          [path.join(outputPath, `${fileName}@2x.jpg`)]: {
            resizeX: 750,
            resizeY: null,
            crop: null
          },
          [path.join(outputPath, `${fileName}.jpg`)]:{
            resizeX: 375,
            resizeY: null,
            crop: null
          }
        }
      })
    }

    if( obj[key].hasOwnProperty('children')) {
      await processMapping(obj[key].children, theme, style, parentName !== "" ? parentName + "_"+ key : key)
    }
  }
}


(async () => {
  const pageMap = await JSON.parse(fs.readFileSync(path.join(__dirname, '../page_map.json'), 'utf8'))

  const themes = {
    orion:  ['blue', 'purple', 'orange', 'green'],
    gemini: ['blue', 'ocean', 'amber', 'granite'],
    auriga: ['blue', 'green', 'red', 'yellow'],
    lyra:   ['charcoal', 'lime', 'raspberry', 'azure']
  }


  for(let theme of Object.keys(themes)) {
    for(let style of themes[theme]) {
      const shotDir = path.join(__dirname, 'shots', theme, style)
      await rimraf(shotDir)
      await mkdirp(shotDir)
      await generateHeroShots(theme, style, shotDir);
      //await processMapping(pageMap, theme, style);
    }
  }

  console.log(`[ INITIALIZING ]  There are ${renderJobCount} jobs to process...`)

  RENDER_JOBS.process('renderjob', 8, async function processRenderJobs(renderJob, done) {
    const browser = await puppeteer.connect({ browserWSEndpoint: 'ws://localhost:3000' });
    const page = await browser.newPage();
    await page.setViewport({width: 1400, height: 1600, deviceScaleFactor: 2});

    renderJob.log(`[ PROCESSING ] Snapshotting ${renderJob.data.theme} - ${renderJob.data.style}: ${renderJob.data.displayTitle}`)
    await snapshotElement(page, renderJob.data.targetUrl, renderJob.data.selector, renderJob.data.displayTitle, renderJob.data.outputPath, renderJob.data.fileName).catch(function(err){
      throw new Error( 'bad things happen' );
    });

    renderJob.log(`[ PROCESSING ] Resizing ${renderJob.data.theme} - ${renderJob.data.style}: ${renderJob.data.displayTitle}`)
    await resizeJob(renderJob.data.resizeStack);
    renderJob.log(`[ PROCESSING ] Resizing done.`)

    await browser.close();
    renderJobCount -= 1
    done && done()
  })
})();


