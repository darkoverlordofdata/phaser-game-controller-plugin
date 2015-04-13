#
# Ash Components
#
Components = do ->
  Collector: class Collector
    player  : null
    object  : null
    listener : null
    constructor: (@player, @object, @listener) ->
  Collision: class Collision
    a       : null
    b       : null
    constructor: (@a, @b) ->
  Player: class Player
    sprite        : null
    stand         : 0
    velocityHorz  : 0
    velocityVert  : 0
    cursors       : null
    controller    : null
    constructor: (@sprite, @stand, @velocityHorz, @velocityVert, @cursors, @controller) ->
#
# Ash Nodes
#
Nodes = do ->
  CollisionNode: class CollisionNode
    collision : Components.Collision
  CollectorNode: class CollectorNode
    collector : Components.Collector
  PlayerNode: class PlayerNode
    player    : Components.Player


class Demo

  PHYSICS_TO_USE              = Phaser.Physics.ARCADE
  SYSTEM_PRE_UPDATE           = 1
  SYSTEM_UPDATE               = 2
  SYSTEM_MOVE                 = 3
  SYSTEM_RESOLVE_COLLISIONS   = 4
  SYSTEM_STATE_MACHINES       = 5
  SYSTEM_ANIMATE              = 6
  SYSTEM_RENDER               = 7


  height          : window.innerHeight
  width           : window.innerWidth
  scale           : window.devicePixelRatio

  game            : null  # Phaser.Game
  ash             : null  # Ash Engine
  platforms       : null  # platform group
  stars           : null  # star group
  scoreListener   : null  # Phaser.Signal
  cursors         : null  # player controller
  score           : 0

  constructor: () ->
    @game = new Phaser.Game(800, 600, Phaser.CANVAS, '',
      init: @init, preload: @preload, create: @create)


  ### ============================================================>
      set phaser scaling
  <============================================================ ###
  init: =>
    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    return

  ### ============================================================>
      Preload assets
  <============================================================ ###
  preload: =>
    @game.load.image 'sky', 'assets/sky.png'
    @game.load.image 'ground', 'assets/platform.png'
    @game.load.image 'star', 'assets/star.png'
    @game.load.spritesheet 'dude', 'assets/dude.png', 32, 48
    return

  ### ============================================================>
      Create the game
  <============================================================ ###
  create: =>

    game = @game

    @stars = game.add.group()
    @platforms = game.add.group()
    @scoreListener = new Phaser.Signal()
    @cursors = game.input.keyboard.createCursorKeys()

    @profiler = game.plugins.add(Phaser.Plugin.PerfMonPlugin, x:720)
    @ash = game.plugins.add(ash.ext.PhaserPlugin, Nodes, Components)
    @controller = @game.plugins.add(Phaser.Plugin.GameControllerPlugin, force: true)

    @createBackground('sky')
    @createGround('ground')
    @createLedge('ground', 400, 400)
    @createLedge('ground', -150, 250)
    @createStars('star', 70, 0, 12, 10)
    @createPlayer('dude', 150, 350)
    @createScore(16, 16, 'score: 0', fontSize: '32px', fill: '#000')

    @ash.addSystem(new CollisionSystem(this), SYSTEM_RESOLVE_COLLISIONS)
    @ash.addSystem(new PlayerMovementSystem(this), SYSTEM_MOVE)
    @ash.addSystem(new CollectorSystem(this), SYSTEM_UPDATE)

    @controller.start()
    return


  ### ============================================================>
      Create a background
  <============================================================ ###
  createBackground: (key) ->

    # phaser sprite
    sprite = @game.add.sprite(0, 0, key)
    @game.world.sendToBack(sprite)
    @game.physics.enable(sprite, PHYSICS_TO_USE)

    # ash entity
    sky = new ash.core.Entity('sky').add(sprite)
    @ash.addEntity(sky)
    return

  ### ============================================================>
      Create the ground
  <============================================================ ###
  createGround: (key) ->

    # phaser sprite
    sprite = @platforms.create(0, @game.world.height - 64, key)
    sprite.scale.setTo(2, 2)
    @game.physics.enable(sprite, PHYSICS_TO_USE)
    sprite.body.immovable = true

    # ash entity
    ground = new ash.core.Entity('ground').add(sprite)
    @ash.addEntity(ground)
    return

  ### ============================================================>
      Create a ledge
  <============================================================ ###
  createLedge: (key, x, y) ->

    # phaser sprite
    sprite = @platforms.create(x, y, key)
    @game.physics.enable(sprite, PHYSICS_TO_USE)
    sprite.body.immovable = true

    # ash entity
    ledge = new ash.core.Entity().add(sprite)
    @ash.addEntity(ledge)
    return

  ### ============================================================>
      Create the player
  <============================================================ ###
  createPlayer: (key, velocityHorz, velocityVert) ->

    # phaser sprite
    sprite = @game.add.sprite(32, @game.world.height - 150, key)
    @game.physics.enable(sprite, PHYSICS_TO_USE);
    sprite.body.bounce.y = 0.2
    sprite.body.gravity.y = 60
    sprite.body.collideWorldBounds = true
    sprite.animations.add 'left', [0, 1, 2, 3], 10, true
    sprite.animations.add 'right', [5, 6, 7, 8], 10, true

    # ash entity
    player = new ash.core.Entity().add(sprite)
    .add(new Components.Collision(sprite, @platforms))
    .add(new Components.Collector(sprite, @stars, @scoreListener))
    .add(new Components.Player(sprite, 4, velocityHorz, velocityVert, @cursors, @controller))
    @ash.addEntity(player)
    return

  ### ============================================================>
      Create the score
  <============================================================ ###
  createScore: (x, y, text, style) ->
    sprite = @game.add.text(x, y, text, style)

    score = new ash.core.Entity().add(sprite)
    @ash.addEntity(score)

    @scoreListener.add (points) =>
      @score += parseInt(points, 10)
      sprite.setText('Score: ' + @score)
    return


  ### ============================================================>
      Create stars
  <============================================================ ###
  createStars: (key, x, y, count, points) ->

    # phaser group
    @stars.enableBody = true
    @stars.physicsBodyType = Phaser.Physics.ARCADE

    # ash entity
    stars = new ash.core.Entity().add(@stars)
    .add(new Components.Collision(@stars, @platforms))
    @ash.addEntity(stars)

    for i in [0...count]
      # phaser sprite
      sprite = @stars.create(i*x, y, key)
      sprite.name = ''+points
      @game.physics.enable(sprite, PHYSICS_TO_USE)
      sprite.body.gravity.y = 160
      sprite.body.bounce.y = 0.7 + Math.random() * 0.2

      # ash entity
      star = new ash.core.Entity().add(sprite)
      @ash.addEntity(star)

    return

