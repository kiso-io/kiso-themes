const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');
const rimraf = require('rimraf-promise');
const mkdirp = require('mkdirp-promise');

const sharp = require('sharp');

(async () => {

  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Adjustments particular to this page to ensure we hit desktop breakpoint.
  page.setViewport({width: 1400, height: 1600, deviceScaleFactor: 2});

  async function screenshotDOMElement(opts = {}) {
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

  const pageMap = await JSON.parse(fs.readFileSync(path.join(__dirname, '../page_map.json'), 'utf8'))

  async function changeTheme(theme, style) {
    var targetUrl = `http://localhost:4000/preview/main?theme=${theme}&style=${style}`;
    console.log(`Changing theme to ${theme} - ${style}`)

    await page.goto(targetUrl, { waitUntil: 'networkidle2' });
  }

  async function generateHeroShots(theme, style, outputPath) {
    var targetUrl = `preview/001_dashboards@ti-dashboard/001_dashboard_1`;
    console.log(`Generating hero shots ${theme} - ${style}`)

    await snapshotElement(targetUrl, 'body', 'hero_shot', outputPath, 'hero_shot')

    let filePath = path.join(outputPath, 'hero_shot_source.jpg')

    console.log(`Resizing shot: ${filePath}`)
    await sharp(filePath)
          .resize(2800, 920)
          .crop(sharp.gravity.north)
          .toFile( path.join(outputPath, `hero_shot@2x.jpg`))

    await sharp(filePath)
          .resize(1400, 460)
          .crop(sharp.gravity.north)
          .toFile( path.join(outputPath, `hero_shot.jpg`))

    await sharp(filePath)
          .resize(760, 356)
          .crop(sharp.gravity.north)
          .toFile( path.join(outputPath, `shot@2x.jpg`))

    await sharp(filePath)
          .resize(380, 178)
          .crop(sharp.gravity.north)
          .toFile( path.join(outputPath, `shot.jpg`))

    fs.unlinkSync( path.join(outputPath, `hero_shot_source.jpg`))
  }

  async function snapshotElement(url, selector, displayTitle, outputPath, fileName) {
    var targetUrl = 'http://localhost:4000/' + url;
    console.log(`Snapshotting ${displayTitle} - ${targetUrl}`)

    await page.goto(targetUrl, { waitUntil: 'networkidle2' });
    await page.evaluate("$(window).off('resize'); $('.nav-side-container').slimScroll({destroy: true}); $('.nav-side-container').css('overflow', 'visible').css('height', '100%'); $('.inspect-mode').remove()")

    const filePath = path.join(outputPath, fileName+'_source.jpg');
    await screenshotDOMElement({
      path: filePath,
      selector: selector,
      fullScreen: true,
      padding: 0
    });
  }

  async function processMapping(obj, theme, style, parentName = '') {
    for(let key of Object.keys(obj)) {
      if( obj[key].hasOwnProperty('preview_url')) {
        let previewUrl = 'preview/' + obj[key].preview_url;
        let selector = obj[key].snapshot_selector;
        let displayTitle = obj[key].display_title;
        const outputPath = path.join(__dirname, 'shots', theme, style)
        let fileName = parentName + "_" + displayTitle.replace(/[\s]+/gi, "_").replace(/;/,"").toLowerCase();

        await snapshotElement(previewUrl, selector, displayTitle, outputPath, fileName)

        let filePath = path.join(outputPath, fileName)

        console.log(`Resizing shot: ${filePath}`)
        await sharp(filePath)
          .resize(700, null)
          .toFile( path.join(outputPath, `${fileName}@2x.jpg`))

        await sharp(filePath)
          .resize(350, null)
          .toFile( path.join(outputPath, `${fileName}.jpg`))

        fs.unlinkSync( path.join(outputPath, `${fileName}_source.jpg`))
      }

      if( obj[key].hasOwnProperty('children')) {
        await processMapping(obj[key].children, theme, style, parentName !== "" ? parentName + "_"+ key : key)
      }
    }
  }

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


      await changeTheme(theme, style);
      await generateHeroShots(theme, style, shotDir);
      await processMapping(pageMap, theme, style);
    }
  }


  console.log('closing browser')
  browser.close();
})();
