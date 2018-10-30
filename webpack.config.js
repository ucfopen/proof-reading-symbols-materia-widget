// load the reusable legacy webpack config from materia-widget-dev
const widgetWebpack = require('materia-widget-development-kit/webpack-widget')
const entries = widgetWebpack.getDefaultEntries()
// no creator
delete entries['creator.css']
delete entries['creator.js']

// options for the build
let options = {
	entries: entries
}

module.exports = widgetWebpack.getLegacyWidgetBuildConfig(options)
