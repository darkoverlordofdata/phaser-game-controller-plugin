class Example extends Phaser.Game

  constructor: ->

    super 800, 600, Phaser.AUTO
    @state.add 'Stage', Stage, false
    @state.start 'Stage'

