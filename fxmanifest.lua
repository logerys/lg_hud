fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_script '@ox_lib/init.lua'

-- Script Description
description 'Logerys hud'

exports {
	'ToggleNews',
	'isTalking',
	'changeVoiceLevel'
}
files {
	'html/logo.png',
	'html/index.html',
	'html/main.css',
	'html/main.js',
}

ui_page 'html/index.html'

client_scripts {
	'MinimapValues.lua',
	'RadarWhileDriving.lua',
	'client.lua',
}