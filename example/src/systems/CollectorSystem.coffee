class CollectorSystem extends ash.tools.ListIteratingSystem

  game: null

  constructor: (parent) ->
    super(parent.ash.nodes.CollectorNode, @updateNode)
    @game = parent.game

  updateNode: (node, time) =>

    collector = node.collector

    @game.physics.arcade.overlap collector.player, collector.object, (player, object) =>
      object.kill()
      collector.listener.dispatch(object.name)

