config = require './config.coffee'

class State

  constructor: (game)->

  preload: ->
    @game.stage = $.extend @game.stage, config.stage
    @game.load.image imageName, path for imageName, path of config.images
    @game.load.audio audioName, path for audioName, path of config.audio

  create: ->
    @soundsInit()
    @playerInit()
    @obstacleInit()
    @goodiesInit()


    @timer = @game.time.events.loop 3000, @addBlock, this
    @goodieTimer = @game.time.events.loop 5000, @addGoodie, this

    @score = -2
    style = font: '22px Arial', fill:'#ffffff'

    @scoreLabel = @game.add.text @game.width - 10, @game.height - 10, '0', style
    @scoreLabel.anchor.setTo 2, 1

    @gameSpeed = 1

  soundsInit: ->
    @tunes = this.add.audio('music')
    @deadSound = this.add.audio('dead')
    @powerupSound = this.add.audio('pup')
    @tunes.play()

  playerInit: ->
    @player = @game.add.sprite 0, 0, 'ship'
    @player.anchor.setTo -1, -2.5
    @player.scale.setTo .1, .1
    # @player.tint = 0x00CCFF
    # @game.camera.follow @player
    @game.physics.arcade.enable @player
    @player.body.gravity.y = 70

  obstacleInit: ->
    @blocks = @game.add.group()
    @blocks.createMultiple 5, 'block'
    @blocks.setAll 'scale.y', 1.5
    @blocks.setAll 'scale.x', 1.5
    @game.physics.arcade.enable @blocks

  goodiesInit: ->
    @goodies = @game.add.group()
    @goodies.setAll 'scale.y', 2
    @goodies.setAll 'scale.x', 2
    @goodies.setAll 'tint' , '0000FF'
    @goodies.createMultiple 20, 'star'

    @game.physics.arcade.enable @goodies

  update: ->
    # controls
    @move_y -1 if @input.keyboard.isDown Phaser.Keyboard.UP
    @move_y  1 if @input.keyboard.isDown Phaser.Keyboard.DOWN

    # dat Collision mang.
    @gameOver() if @player.body.bottom >= @world.bounds.bottom
    @game.physics.arcade.overlap @player, @blocks, @gameOver, null, this
    @game.physics.arcade.overlap @player, @goodies, @goodieGrab, null, this
    @game.physics.arcade.collide @blocks, @goodies, null, null, this

  # Movements!
  move_x: (direction)->
    @player.body.velocity.x = 0
    @player.body.x += direction

  move_y: (direction)->
    @player.body.velocity.y = direction * 50

  addBlock: ->
    block = @blocks.getFirstDead()
    nth = Math.floor Math.random() * 3

    block.reset @game.width, nth * this.game.height/3
    block.body.velocity.x = -150
    block.checkWorldBounds = yes
    block.outOfBoundsKill = yes

    @gameSpeed *= 1.02

    @timer.delay /= 1.02

    @blocks.forEachAlive (aliveBlock)=>
      aliveBlock.body.velocity.x = -150 * @gameSpeed

  addGoodie: ->
    goodie = @goodies.getFirstDead()
    nth = Math.floor Math.random() * 3
    goodie.reset @game.width, nth * this.game.height/3
    goodie.body.velocity.x = -150
    goodie.checkWorldBounds = yes
    goodie.outOfBoundsKill = yes

    @gameSpeed *= 1.02

    @timer.delay /= 1.02

    @goodies.forEachAlive (aliveGoodie)=>
      aliveGoodie.body.velocity.x = -150 * @gameSpeed

  goodieGrab: (player, goody) =>
    @setScore()
    @powerupSound.play()
    goody.kill()

  setScore: ->
    if @score < 0
      @score = 1
    else
      @score++
    @scoreLabel.text = @score

  gameOver: ->
    @deadSound.play()
    @game.state.start 'mainmenu'
    @game.time.events.remove @timer
    @tunes.stop()

module.exports = State