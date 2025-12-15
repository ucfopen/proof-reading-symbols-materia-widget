const path = require('path')
const srcPath = path.join(process.cwd(), 'src')
const widgetWebpack = require('materia-widget-development-kit/webpack-widget')

const entries = widgetWebpack.getDefaultEntries()

// using default creator
delete entries['creator'];

// not using coffeescript here
entries['player'] = [
	path.join(srcPath, 'player.html'),
	path.join(srcPath, 'player.coffee'),
	path.join(srcPath, 'player.scss')
];

let options = {
	entries: entries,
}

module.exports = widgetWebpack.getLegacyWidgetBuildConfig(options)