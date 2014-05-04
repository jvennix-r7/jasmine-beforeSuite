jasmine-beforeSuite provides a "beforeSuite" global for the [Jasmine](http://jasmine.github.io/) behavior-driven development framework for testing JavaScript code.

Any function that is passed to the `beforeSuite` and `afterSuite` global functions will be stored and ran at the appropriate time. So functions passed to `beforeSuite` will be run *only once*, before all the functions passed to `beforeEach` inside the suite.

### Example Usage

    beforeSuite ->
      window.globalCondition = new Foobar()

    afterSuite ->
      delete window.globalCondition

### Building source

    $ npm i
    $ ./jake build

### Running specs

    $ ./jake spec

### License

[MIT](http://en.wikipedia.org/wiki/MIT_License)

### Copyright

Rapid7 2014
