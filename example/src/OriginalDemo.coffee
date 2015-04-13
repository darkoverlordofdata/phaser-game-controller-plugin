###
  This is the original non-ash version of the tutorial
  its about 150 lines, where the ash version comes out a
  little over 300 lines...
###
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
      init: @init, preload: @preload, create: @create, update: @update)


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

  preload: =>
    @game.load.image 'sky', 'assets/sky.png'
    @game.load.image 'ground', 'assets/platform.png'
    @game.load.image 'star', 'assets/star.png'
    @game.load.spritesheet 'dude', 'assets/dude.png', 32, 48

  create: =>

    game = @game
    @profiler = game.plugins.add(Phaser.Plugin.PerfMonPlugin, x:720)

    #  A simple background for our game
    sprite = game.add.sprite(0, 0, 'sky')
    game.physics.enable(sprite, Phaser.Physics.ARCADE);

    #  The platforms group contains the ground and the 2 ledges we can jump on
    @platforms = game.add.group()

    # Here we create the ground.
    ground = @platforms.create(0, game.world.height - 64, 'ground')
    game.physics.enable(ground, Phaser.Physics.ARCADE);

    #  Scale it to fit the width of the game (the original sprite is 400x32 in size)
    ground.scale.setTo 2, 2

    #  This stops it from falling away when you jump on it
    ground.body.immovable = true

    #  Now let's create two ledges
    ledge = @platforms.create(400, 400, 'ground')
    game.physics.enable(ledge, Phaser.Physics.ARCADE);
    ledge.body.immovable = true

    ledge = @platforms.create(-150, 250, 'ground')
    game.physics.enable(ledge, Phaser.Physics.ARCADE);
    ledge.body.immovable = true

    # The player and its settings
    @player = game.add.sprite(32, game.world.height - 150, 'dude')
    game.physics.enable(@player, Phaser.Physics.ARCADE);

    #  Player physics properties. Give the little guy a slight bounce.
    @player.body.bounce.y = 0.2
    @player.body.gravity.y = 60
    @player.body.collideWorldBounds = true

    #  Our two animations, walking left and right.
    @player.animations.add 'left', [0, 1, 2, 3], 10, true
    @player.animations.add 'right', [5, 6, 7, 8], 10, true

    #  Finally some stars to collect
    @stars = @add.group()
    @stars.enableBody = true
    @stars.physicsBodyType = Phaser.Physics.ARCADE

    #  Here we'll create 12 of them evenly spaced apart
    for i in [0...12]
      #  Create a star inside of the 'stars' group
      star = @stars.create(i * 70, 0, 'star')

      #  Let gravity do its thing
      star.body.gravity.y = 160

      #  This just gives each star a slightly random bounce value
      star.body.bounce.y = 0.7 + Math.random() * 0.2

    #  The score
    @scoreText = @add.text(16, 16, 'score: 0', { fontSize: '32px', fill: '#000' })

    #  Our controls.
    @cursors = game.input.keyboard.createCursorKeys()



  update: =>

    game = @game
    #  Collide the player and the stars with the platforms
    game.physics.arcade.collide(@player, @platforms)
    game.physics.arcade.collide(@stars, @platforms)

    #  Checks to see if the player overlaps with any of the stars, if he does call the collectStar function
    game.physics.arcade.overlap(@player, @stars, @collectStar, null, this)

    #  Reset the players velocity (movement)
    @player.body.velocity.x = 0

    if (@cursors.left.isDown)
      #  Move to the left
      @player.body.velocity.x = -150

      @player.animations.play('left')

    else if (@cursors.right.isDown)
      #  Move to the right
      @player.body.velocity.x = 150

      @player.animations.play('right')

    else
      #  Stand still
      @player.animations.stop()

      @player.frame = 4

    #  Allow the player to jump if they are touching the ground.
    if (@cursors.up.isDown and @player.body.touching.down)
      @player.body.velocity.y = -350

  collectStar: (player, star) =>

    # Removes the star from the screen
    star.kill()

    #  Add and update the score
    @score += 10
    @scoreText.setText('Score: ' + @score)
