config = require './config.coffee'

class MainMenu

  constructor: (game)->

  preload: ->
    @game.stage = $.extend @game.stage, config.stage
    @game.load.image imageName, path for imageName, path of config.images

  create: ->
    @instructionsLabel = @game.add.text @game.width/2, @game.height/2,
      """
        Better than Hot Potato. Press 'S' to start.
      """
    , font: '32px Arial', fill: '#ffffff', align: 'center'
    @instructionsLabel.anchor.setTo 0.5, 0.5
    @game.add.tween(@instructionsLabel).delay(3000).to({alpha: 0}, 1500)

  resizeGame = ->
    game.stage.scale.refresh()

  update: ->
    @restartGame() if @input.keyboard.isDown Phaser.Keyboard.S

  restartGame: ->
      @game.state.start 'game'

module.exports = MainMenu
