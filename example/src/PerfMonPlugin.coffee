###
 *
 * JavaScript Performance Monitor Plugin
 *
 * @see https://github.com/mrdoob/stats.js
 *
 *  @game.plugins.add(Phaser.Plugin.PerfMonPlugin, x: 100, y: 100, mode: 1)
 *
###
class Phaser.Plugin.PerfMonPlugin extends Phaser.Plugin

  stats           : null
  visible         : false
  active          : false
  hasPreUpdate    : false
  hasPostRender   : false

  ###
   * @param   game    current phaser game context
   * @param   parent  current phaser state context
  ###
  constructor: (game, parent) ->
    super game, parent

  ###
   * @param   options:
   *            x           position.x
   *            y           position.y
   *            container   DOM Element
   *            mode        initial stats mode
  ###
  init: (options = {}) ->
    if Stats?
      if options.container?
        container = options.container
      else
        container = document.createElement('div')
        document.body.appendChild container

      @stats = new Stats()
      container.appendChild @stats.domElement
      @stats.domElement.style.position = 'absolute'
      x = options.x ? 0
      y = options.y ? 0
      @stats.setMode options.mode ? 0
      @stats.domElement.style.position = "absolute"
      @stats.domElement.style.left = "#{x}px"
      @stats.domElement.style.top = "#{y}px"

      @active = true
      @visible = true
      @hasPreUpdate = true
      @hasPostRender = true

    else # turn the plugin off
      @preUpdate = ->   # set to empty
      @postRender = ->  # set to empty

  ###
   * The beginning of the game loop
  ###
  preUpdate: ->
    @stats.begin()
    return

  ###
   * The end of the game loop
  ###
  postRender: ->
    @stats.end()
    return

