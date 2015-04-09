
     ______               __     __
    /_  __/__ __ _  ___  / /__ _/ /____
     / / / -_)  ' \/ _ \/ / _ `/ __/ -_)
    /_/  \__/_/_/_/ .__/_/\_,_/\__/\__/
              ___/_/    ______
             / ___/__  / _/ _/__ ___
           _/ /__/ _ \/ _/ _/ -_) -_)
          (_)___/\___/_//_/ \__/\__/




#Template.coffee

Coffeescript project template


 Tasks:

* test  - run tests
* zip   - create build/{{project}}.zip and copy to device

* build - build sources to web/packages/{{lib}} & web/packages/example
            if lib/filelist is found, use that to concat files.
            otherwise, let browserify sort it out.
* get   - gets package dependencies using bower
* deps  - list dependencies
* gh    - publish gh-pages


        project
        | -- bin                    tools
        | -- build                  output folder for zip
        | -- example                example using the lib
        | -- lib                    defines this package
        | -- node_modules           npm dependencies
        | -- packages               bower external packages
        | -- (tmp)                  temporary
        | -- web                    source
        |     | -- index.html
        |     | -- main.js          starts lib.main()
        |     + -- packages         packages + lib
        |           | -- {{lib}}
        |           | -- example
        |           | -- other...
        |
        | -- .bowerrc               define ./packages
        | -- .gitignore             build, node_modules, tmp, packages
        | -- bower.json             module name, packages
        | -- Gruntfile.coffee       this workflow
        | -- license.md
        | -- package.json           output package name
        + -- readme.md




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
