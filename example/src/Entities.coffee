#+--------------------------------------------------------------------+
#| entities.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2015
#+--------------------------------------------------------------------+
#|
#| This file is a part of asteroids.coffee
#|
#| asteroids.coffee is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
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
    cursors        : null
    constructor: (@sprite, @stand, @velocityHorz, @velocityVert, @cursors) ->
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


#
# Fabricate Entities
#
class Entities

  PHYSICS_TO_USE = Phaser.Physics.ARCADE
  
  game            : null  # Phaser.Game
  ash             : null  # Ash Engine
  platforms       : null  # platform group
  stars           : null  # star group
  scoreListener   : null  # Phaser.Signal
  score           : 0

  constructor: (@parent) ->
    @game = @parent.game
    @ash = @parent.ash
    @stars = @game.add.group()
    @platforms = @game.add.group()
    @scoreListener = new Phaser.Signal()


  ###
   * Remove the entity
  ###
  destroyEntity: (entity) ->
    @ash.removeEntity entity
    return

  ###
   * Create a background
  ###
  createBackground: (key) ->
    # phaser sprite
    sprite = @game.add.sprite(0, 0, key)
    @game.world.sendToBack(sprite)
    @game.physics.enable(sprite, PHYSICS_TO_USE)

    # ash entity
    sky = new ash.core.Entity('sky').add(sprite)
    @ash.addEntity(sky)
    return

  ###
   * Create the ground
  ###
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

  ###
   * Create a ledge
  ###
  createLedge: (key, x, y) ->
    # phaser sprite
    sprite = @platforms.create(x, y, key)
    @game.physics.enable(sprite, PHYSICS_TO_USE)
    sprite.body.immovable = true

    # ash entity
    ledge = new ash.core.Entity().add(sprite)
    @ash.addEntity(ledge)
    return

  ###
   * Create the player
  ###
  createPlayer: (key, velocityHorz, velocityVert, cursors) ->
    # phaser sprite
    sprite = @game.add.sprite(32, @game.world.height - 150, key)
    @game.physics.enable(sprite, PHYSICS_TO_USE);

    #  Player physics properties. Give the little guy a slight bounce.
    sprite.body.bounce.y = 0.2
    sprite.body.gravity.y = 60
    sprite.body.collideWorldBounds = true

    #  Our two animations, walking left and right.
    sprite.animations.add 'left', [0, 1, 2, 3], 10, true
    sprite.animations.add 'right', [5, 6, 7, 8], 10, true

    # ash entity
    player = new ash.core.Entity().add(sprite)
    .add(new Components.Collision(sprite, @platforms))
    .add(new Components.Collector(sprite, @stars, @scoreListener))
    .add(new Components.Player(sprite, 4, velocityHorz, velocityVert, cursors))
    @ash.addEntity(player)
    return

  ###
   * Create the score
  ###
  createScore: (x, y, text, style) ->
    sprite = @game.add.text(x, y, text, style)

    score = new ash.core.Entity().add(sprite)
    @ash.addEntity(score)

    @scoreListener.add (points) =>
      @score += parseInt(points, 10)
      sprite.setText('Score: ' + @score)
    return


  ###
   * Create the stars
  ###
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

