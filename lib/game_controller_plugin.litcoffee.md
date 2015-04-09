example usages

```coffee
@con.joystick
@con.dpad
@con.buttons

@con.left
@con.right
```
```coffee


@con = @game.plugins.add(Phaser.Plugin.GameconPlugin)

@con.addDPad 'left', 60, @height-60,
up: width: '7%', height: '7%'
down: false
left: width: '7%', height: '7%'
right: width: '7%', height: '7%'

@con.addDPad
left: 60, @height-60,
up: width: '7%', height: '7%'
down: false
left: width: '7%', height: '7%'
right: width: '7%', height: '7%'
right: @width-60, @height-60,
up: width: '7%', height: '7%'
down: false
left: width: '7%', height: '7%'
right: width: '7%', height: '7%'

@con.addButtons 'right', @width-180, @height-80,
1: title: 'WARP', color: 'yellow'
3: title: 'FIRE', color: 'red'

@con.addButtons
left: 180, @height-80,
1: title: 'WARP', color: 'yellow'
3: title: 'FIRE', color: 'red'
right: @width-180, @height-80,
1: title: 'WARP', color: 'yellow'
3: title: 'FIRE', color: 'red'


@con.addJoystick 'left', 60, @height-60
@con.addJoystick
left: x: 60, y: @height-60
right: x: @width-60, y: @height-60


```