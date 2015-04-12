class Demo

  height      : window.innerHeight
  width       : window.innerWidth
  scale       : window.devicePixelRatio

  player      : null
  platforms   : null
  cursors     : null

  stars       : null
  score       : 0
  scoreText   : null


  ###
   * Create the phaser game component
  ###
  constructor: () ->
    # initialize the game
    @game = new Phaser.Game(@width * @scale, @height * @scale, Phaser.CANVAS, '',
      init: @init, preload: @preload, create: @create)


  ###
   * Configure Phaser scaling
  ###
  init: =>
    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @game.scale.minWidth = @width * @scale
    @game.scale.minHeight = @height * @scale
    @game.scale.maxWidth = @width * @scale
    @game.scale.maxHeight = @height * @scale
    @game.scale.pageAlignVertically = true
    @game.scale.pageAlignHorizontally = true
    return

  ###
   * Preload the assets
  ###
  preload: =>
    @game.load.image 'sky', 'assets/sky.png'
    @game.load.image 'ground', 'assets/platform.png'
    @game.load.image 'star', 'assets/star.png'
    @game.load.spritesheet 'dude', 'assets/dude.png', 32, 48


  ###
   * Create ces
  ###
  create: =>

    game = @game
    cursors = game.input.keyboard.createCursorKeys()

    @profiler = game.plugins.add(Phaser.Plugin.PerfMonPlugin, x:720)
    @ash = game.plugins.add(ash.ext.PhaserPlugin, Nodes, Components)
    @entities = new Entities(this)
    @entities.createBackground('sky')
    @entities.createGround('ground')
    @entities.createLedge('ground', 400, 400)
    @entities.createLedge('ground', -150, 250)
    @entities.createStars('star', 70, 0, 12, 10)
    @entities.createPlayer('dude', 150, 350, cursors)
    @entities.createScore(16, 16, 'score: 0', fontSize: '32px', fill: '#000')

    @ash.addSystem(new CollisionSystem(this), SystemPriorities.update)
    @ash.addSystem(new PlayerMovementSystem(this), SystemPriorities.update)
    @ash.addSystem(new CollectorSystem(this), SystemPriorities.update)


