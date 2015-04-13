###
 *
 * Html5 Virtual Game Controller
 *
 * @see https://github.com/austinhallock/html5-virtual-game-controller
 *
 *  @game.plugins.add(Phaser.Plugin.GameController)
 *
###
class Phaser.Plugin.GameControllerPlugin extends Phaser.Plugin


  options   : null
  joystick  : undefined
  buttons   : undefined
  dpad      : undefined
  left      : undefined
  right     : undefined

  ###
   * @param   game    current phaser game context
   * @param   parent  current phaser state context
  ###
  constructor: (game, parent) ->
    super game, parent
    @options = {}

  ###
   * @param   extra    extra params passed to the plugin
  ###
  init: (extra={}) =>
    if extra.force
      ###
       * So the virtual pad will display on desktop
      ###
      document.documentElement['ontouchstart'] = ->

  ###
   * Start
  ###
  start: () ->
#    if @game.device.mobile
    if 'ontouchstart' of document.documentElement
      if not @options.left?
        position = GameController.options.left.position
        @options.left =
          position: left: position.left, bottom: position.bottom
          type: 'dpad'
          dpad: {}
        @dpad =
          up: false
          down: false
          left: false
          right: false
        for direction in ['up','down', 'left','right']
          do (direction) => # create a closure for each set of options
            @options.left.dpad[direction] =
              touchStart: =>
                @dpad[direction] = true
                return
              touchEnd: =>
                @dpad[direction] = false
                return
      if not @options.right?
        position = GameController.options.right.position
        @options.right =
          position: right: position.right, bottom: position.bottom
          type: 'buttons'
          buttons: [false, false, false, false]
        @buttons =
          x: false
          y: false
          b: false
          a: false
        for title, index in ['x','y','b','a']
          do (title) => # create a closure for each set of options
            @options.right.buttons[index] =
              touchStart: =>
                @buttons[title] = true
                return
              touchEnd: =>
                @buttons[title] = false
                return

      GameController.init(@game, @options)
    return

  ###
   * Add Side
   *
   * @param   side
   * @param   x
   * @param   y
   * @param   type
   * @param   data
  ###
  addSide: (side, x, y, type, data={}) ->
    @options[side] ?= {}
    @options[side].position = left: x, top:y
    @options[side].type = type
    @options[side][type] = data
    return

  ###
   * Add DPad
   *
   * @param   side
   * @param   x
   * @param   y
   * @param   options
  ###
  addDPad: (side, x, y, directions) ->
    if 'string' is typeof side
      ###
       * Create 1 dpad
      ###
      @dpad =
        up: false
        down: false
        left: false
        right: false
      @addSide side, x, y, 'dpad', background: true
      for direction, options of directions
        do (direction, options) => # create a closure for each set of options
          if options is false
            @options[side].dpad[direction] = false
          else
            @options[side].dpad[direction] =
              width: options.width
              height: options.height
              touchStart: =>
                @dpad[direction] = true
                return
              touchEnd: =>
                @dpad[direction] = false
                return
    else
      ###
       * Create 2 dpads
      ###
      @left =
        up: false
        down: false
        left: false
        right: false
      @right =
        up: false
        down: false
        left: false
        right: false

      options = side.left
      @addSide options.side, options.x, options.y, 'dpad', background: true
      for direction, options of options.directions
        do (direction, options) => # create a closure for each set of options
          if options is false
            @options[side].dpad[direction] = false
          else
            @options[side].dpad[direction] =
              width: options.width
              height: options.height
              touchStart: =>
                @left[direction] = true
                return
              touchEnd: =>
                @left[direction] = false
                return

      options = side.right
      @addSide options.side, options.x, options.y, 'dpad', background: true
      for direction, options of options.directions
        do (direction, options) => # create a closure for each set of options
          if options is false
            @options[side].dpad[direction] = false
          else
            @options[side].dpad[direction] =
              width: options.width
              height: options.height
              touchStart: =>
                @right[direction] = true
                return
              touchEnd: =>
                @right[direction] = false
                return


  ###
   * Add Joystick
   *
   * @param   side
   * @param   x
   * @param   y
   * @param   radius
  ###
  addJoystick: (side, x, y, radius=x) ->

    if 'string' is typeof side
      ###
       * Create 1 joystick
      ###
      @joystick = null

      @addSide side, x, y, 'joystick',
        touchStart: ->
        touchEnd: =>
          @joystick = null
          return
        touchMove: (joystick) =>
          @joystick = joystick
          return
      @options[side].radius = radius

    else
      ###
       * Create 2 joysticks
      ###
      @left = null
      @right = null

      options = side.left
      options.radius ?= 60
      @addSide options.side, options.x, options.y, 'joystick',
        touchStart: ->
        touchEnd: =>
          @left = null
          return
        touchMove: (joystick) =>
          @left = joystick
          return
      @options[side].radius = options.radius

      options = side.right
      options.radius ?= 60
      @addSide options.side, options.x, options.y, 'joystick',
        touchStart: ->
        touchEnd: =>
          @right = null
          return
        touchMove: (joystick) =>
          @right = joystick
          return
      @options[side].radius = options.radius
    return

  ###
   * Add DPad
   *
   * @param   side
   * @param   x
   * @param   y
   * @param   buttons
  ###
  addButtons: (side, x, y, buttons) ->
    if 'string' is typeof side
      ###
       * Create 1 set of buttons
      ###
      @buttons = {}

      @addSide side, x, y, 'buttons', [false, false, false, false]
      for index, options of buttons
        do (index, options) => # create a closure for each set of options
          @options[side].buttons[parseInt(index)-1] =
            label: options.title
            radius: "#{options.radius or 5}%"
            fontSize: options.fontSize # or 15
            backgroundColor: options.color
            touchStart: =>
              @buttons[options.title.toLowerCase()] = true
              return
            touchEnd: =>
              @buttons[options.title.toLowerCase()] = false
              return

    else
      ###
       * Create 2 sets of buttons
      ###
      @left = {}
      @right = {}

      options = side.left
      @addSide options.side, options.x, options.y, 'buttons', [false, false, false, false]
      for index, options of options.buttons
        do (index, options) => # create a closure for each set of options
          @options[side].buttons[parseInt(index)-1] =
            label: options.title
            radius: "#{options.radius or 5}%"
            fontSize: options.fontSize # or 15
            backgroundColor: options.color
            touchStart: =>
              @left[options.title.toLowerCase()] = true
              return
            touchEnd: =>
              @right[options.title.toLowerCase()] = false
              return

      options = side.right
      @addSide options.side, options.x, options.y, 'buttons', [false, false, false, false]
      for index, options of options.buttons
        do (index, options) => # create a closure for each set of options
          @options[side].buttons[parseInt(index)-1] =
            label: options.title
            radius: "#{options.radius or 5}%"
            fontSize: options.fontSize # or 15
            backgroundColor: options.color
            touchStart: =>
              @right[options.title.toLowerCase()] = true
              return
            touchEnd: =>
              @right[options.title.toLowerCase()] = false
              return

