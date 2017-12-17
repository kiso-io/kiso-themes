const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');
const rimraf = require('rimraf-promise');
const mkdirp = require('mkdirp-promise');
const sharp = require('sharp');

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
  var targetUrl = 'http://localhost:4000/' + url;
  console.log(`Snapshotting ${displayTitle} - ${targetUrl}`)

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

async function resizeScreenshot(targetFilePath, fileName, destinationFilePath) {
  console.log(`Resizing shot: ${targetFilePath}`)
  await sharp(targetFilePath)
    .resize(700, null)
    .toFile( path.join(destinationFilePath, `${fileName}@2x.jpg`))

  await sharp(targetFilePath)
    .resize(350, null)
    .toFile( path.join(destinationFilePath, `${fileName}.jpg`))

  fs.unlinkSync( targetFilePath )
}

function resizeHeroShot(outputPath, counter) {
  let filePath = path.join(outputPath, `hero_shot_${counter}_source.jpg`)

  var resizer = async function() {
    console.log(`Resizing Hero Shot: ${filePath}`)
    await sharp(filePath)
      .resize(2800, 920)
      .crop(sharp.gravity.north)
      .toFile( path.join(outputPath, `hero_shot_${counter}@2x.jpg`))

    await sharp(filePath)
      .resize(1400, 460)
      .crop(sharp.gravity.north)
      .toFile( path.join(outputPath, `hero_shot_${counter}.jpg`))

    await sharp(filePath)
      .resize(760, 356)
      .crop(sharp.gravity.north)
      .toFile( path.join(outputPath, `shot_${counter}@2x.jpg`))

    await sharp(filePath)
      .resize(380, 178)
      .crop(sharp.gravity.north)
      .toFile( path.join(outputPath, `shot_${counter}.jpg`))

    fs.unlinkSync( path.join(outputPath, `hero_shot_${counter}_source.jpg`))
  }.bind(this)
  resizer();
}

async function generateHeroShots(page, theme, style, outputPath) {
  var targetUrls = [
    `preview/001_dashboards@ti-dashboard/001_dashboard_1`,
    `preview/001_dashboards@ti-dashboard/002_dashboard_2`,
    `preview/001_dashboards@ti-dashboard/003_dashboard_3`,
    `preview/001_dashboards@ti-dashboard/004_dashboard_4`,
  ];

  var counter = 1;

  for(var counter=0; counter < targetUrls.length; counter++) {
    console.log(`Generating hero shots ${theme} - ${style}`)
    var themeString = `?theme=${theme}&style=${style}`

    await snapshotElement(page, targetUrls[counter]+themeString, 'body', 'hero_shot', outputPath, `hero_shot_${counter+1}`)
    resizeHeroShot(outputPath, counter+1)
  }
}

async function processMapping(page, obj, theme, style, parentName = '') {
  for(let key of Object.keys(obj)) {
    if( obj[key].hasOwnProperty('preview_url')) {
      let previewUrl = 'preview/' + obj[key].preview_url;
      let selector = obj[key].snapshot_selector;
      let displayTitle = obj[key].display_title;
      let outputPath = path.join(__dirname, 'shots', theme, style)
      let fileName = parentName + "_" + displayTitle.replace(/[\s]+/gi, "_").replace(/;/,"").toLowerCase();
      let filePath = path.join(outputPath, fileName+"_source.jpg")

      var themeString = `?theme=${theme}&style=${style}`

      await snapshotElement(page, previewUrl+themeString, selector, displayTitle, outputPath, fileName)
      await resizeScreenshot(filePath, fileName, outputPath);
    }

    if( obj[key].hasOwnProperty('children')) {
      await processMapping(page, obj[key].children, theme, style, parentName !== "" ? parentName + "_"+ key : key)
    }
  }
}


(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  const pageMap = await JSON.parse(fs.readFileSync(path.join(__dirname, '../page_map.json'), 'utf8'))

  const themes = {
    orion:  ['blue', 'purple', 'orange', 'green'],
    gemini: ['blue', 'ocean', 'amber', 'granite'],
    auriga: ['blue', 'green', 'red', 'yellow'],
    lyra:   ['charcoal', 'lime', 'raspberry', 'azure']
  }

  page.setViewport({width: 1400, height: 1600, deviceScaleFactor: 2});

  for(let theme of Object.keys(themes)) {
    for(let style of themes[theme]) {
      const shotDir = path.join(__dirname, 'shots', theme, style)
      await rimraf(shotDir)
      await mkdirp(shotDir)
      await generateHeroShots(page,theme, style, shotDir);
      await processMapping(page, pageMap, theme, style);
    }
  }

  console.log('closing browser')
  browser.close();
})();
