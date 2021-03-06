
               __
         ___  / /  ___ ____ ___ ____
        / _ \/ _ \/ _ `(_-</ -_) __/
       / .__/_//_/\_,_/___/\__/_/
      /_/__ ____ ___ _  ___
       / _ `/ _ `/  ' \/ -_)
       \_, /\_,_/_/_/_/\__/        ____
      /___/___  ___  / /________  / / /__ ____
      / __/ _ \/ _ \/ __/ __/ _ \/ / / -_) __/
      \__/\___/_//_/\__/_/ _\___/_/_/\__/_/
         ___  / /_ _____ _(_)__
        / _ \/ / // / _ `/ / _ \
       / .__/_/\_,_/\_, /_/_//_/
      /_/          /___/



#phaser-game-controller-plugin


Based on Html5 Virtual Game Controller

@see https://github.com/austinhallock/html5-virtual-game-controller


Adapted as a plugin for phaser

## Build

```bash
$ git clone https://github.com/darkoverlordofdata/phaser-game-controller-plugin
$ cd phaser-game-controller-plugin
$ npm install
$ grunt get
$ grunt build
```
Then point your browser at ./web/index.html

## Usage

You can choose 1 of 3 types for each of 2 sides (left & right).

For example:

    2 joysticks
    2 dpads
    2 buttton sets
    1 left joystick + 1 right button set
    etc...



```coffee
@con = @game.plugins.add(Phaser.Plugin.GameControllerPlugin)

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
Access as


```coffee
@con.joystick.currentX

@con.dpad.left

@con.buttons.fire

```
Or

```coffee
@con.left.up

@con.right.down
```
## Example
![CocoonJS](assets/device-2015-04-09-114753.png)

[Asteroids in CocoonJS](https://github.com/darkoverlordofdata/asteroids)
```coffee

    @controller = @game.plugins.add(Phaser.Plugin.GameControllerPlugin, force: true)

    @controller.addDPad 'left', 60, @height-60,
      up: width: '7%', height: '7%'
      down: false
      left: width: '7%', height: '7%'
      right: width: '7%', height: '7%'

    @controller.addButtons 'right', @width-180, @height-80,
      1: title: 'warp', color: 'yellow'
      3: title: 'FIRE', color: 'red'
```

# MIT License

Copyright (c) 2015 Bruce Davidson &lt;darkoverlordofdata@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
