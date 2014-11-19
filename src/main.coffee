State = require './lib/state.coffee'
MainMenu = require './lib/mainmenu.coffee'
config = require './lib/config.coffee'

$(document).ready ->
  demo = new Phaser.Game config.width, config.height, Phaser.AUTO
  demo.state.add 'mainmenu', MainMenu, yes
  demo.state.add 'game', State