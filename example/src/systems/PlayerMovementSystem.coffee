class PlayerMovementSystem extends ash.tools.ListIteratingSystem

  game: null

  constructor: (parent) ->
    super(parent.ash.nodes.PlayerNode, @updateNode)
    @game = parent.game

  updateNode: (node, time) =>

    player = node.player
    cursors = player.cursors
    sprite = player.sprite
  
    #  Reset the players velocity (movement)
    sprite.body.velocity.x = 0

    if (cursors.left.isDown)
    #  Move to the left
      sprite.body.velocity.x = -player.velocityHorz

      sprite.animations.play('left')

    else if (cursors.right.isDown)
    #  Move to the right
      sprite.body.velocity.x = player.velocityHorz

      sprite.animations.play('right')

    else
    #  Stand still
      sprite.animations.stop()

      sprite.frame = player.stand

    #  Allow the player to jump if they are touching the ground.
    if (cursors.up.isDown and sprite.body.touching.down)
      sprite.body.velocity.y = -player.velocityVert

