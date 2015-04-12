class CollisionSystem extends ash.tools.ListIteratingSystem

  game: null

  constructor: (parent) ->
    super(parent.ash.nodes.CollisionNode, @updateNode)
    @game = parent.game

  updateNode: (node, time) =>

    collision = node.collision
    @game.physics.arcade.collide(collision.a, collision.b)


