jasmine-beforeSuite provides `beforeSuite` and `afterSuite` global for the [Jasmine](http://jasmine.github.io/) behavior-driven development framework for testing JavaScript code.

Any function that is passed to the `beforeSuite` and `afterSuite` global functions will be stored and ran at the appropriate time. So functions passed to `beforeSuite` will be run *only once*, before all the functions passed to `beforeEach` inside the suite.

### Features

- beforeSuite supports asynchronous functions
- minimal wrapping (only `jasmine.Suite.prototype.finish` is wrapped)
- works in both browser and node.js

### Example Usage

    describe 'a suite', ->

      beforeSuite (done) ->
        setTimeout((-> window.globalCondition = new Foobar(); done()), 10)

      it 'is a Foobar', ->
        expect(globalCondition.constructor).toEqual(Foobar)

      describe 'a nested spec', ->

        it 'is still a Foobar', ->
          expect(globalCondition.constructor).toEqual(Foobar)

      afterSuite (done) ->
        setTimeout((-> delete window.globalCondition), 1000)

    describe 'another suite', ->

      it 'is no longer defined', ->
        expect(globalCondition).not.toBeDefined()

### Building from source

    $ npm i
    $ ./jake build

### Running specs

    $ ./jake spec [DEBUG=1] [SPEC=./spec/before_suite_spec.coffee]

### License

[MIT](http://en.wikipedia.org/wiki/MIT_License)

### Copyright

Rapid7 2014
