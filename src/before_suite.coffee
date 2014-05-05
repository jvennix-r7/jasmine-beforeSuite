#
# jasmine-beforeSuite - 0.1.0
#
# A plugin for the Jasmine behavior-driven Javascript testing framework that
# adds beforeSuite and afterSuite global setup functions.
#
# Works in both node.js and a browser environment.
#
# Requires jasmine.js and underscore.js.
#
# @author Joe Vennix
# @copyright Rapid7 2014
# @see https://github.com/jvennix-r7/jasmine-beforeSuite
#
# Released under the MIT License.
#

install = (_, jasmine) ->

  # returns true if passed +fn+ has one or more arguments
  fnHasNoArgs = (fn) ->
    fnStr = fn.toString()
    _.isEmpty fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(/([^\s,]+)/g)

  # returns true if the recently executed spec was the last one in its suite
  isLastJasmineSpecInSuite = ->
    last = _.last(jasmine.getEnv().currentSpec?.suite?.specs_)
    last?.id == jasmine.getEnv().currentSpec?.id

  @beforeSuite = (fn) ->

    # Similar to _.once, ensure fn() is only called once, and make
    # sure to pass the done() async callback down as necessary.
    suite = jasmine.getEnv().currentSuite
    ran = false
    wrappedFn = if fnHasNoArgs(fn)
       ->
        fn() unless ran
        ran = true
    else
      (done) ->
        if ran then setTimeout(done) else fn(done)
        ran = true

    wrappedFn.isBeforeSuite = true
    beforeEach(wrappedFn) # installs the handler

    # ensure our before() gets called before other beforeEach and after other beforeSuite
    tmpFn = suite.before_.shift()
    lastBeforeSuite = _.find suite.before_, (before) -> before.isBeforeSuite is true
    lastBeforeSuiteIdx = _.indexOf(suite.before_, lastBeforeSuite)
    if !_.isNumber(lastBeforeSuiteIdx) || lastBeforeSuiteIdx == -1
      lastBeforeSuiteIdx = suite.before_.length
    suite.before_.splice(lastBeforeSuiteIdx, 0, tmpFn)

  @afterSuite = (fn) ->
    # We ensure that the after fn is only run after the last spec in its suite
    suite = jasmine.getEnv().currentSuite
    wrappedFn = if fnHasNoArgs(fn)
      afterEach ->
        fn() if isLastJasmineSpecInSuite(suite)
    else
      afterEach (done) ->
        fn(done) if isLastJasmineSpecInSuite(suite)

    # ensure our afterEach() gets called other afterEach's

# Displayed if the user forgets to include jasmine in the environment
warningMsg = "jasmine-beforeSuite: Jasmine must be required first. Aborting."

# Pass the dependencies in different ways for node.js vs. browser
if typeof module != 'undefined' && module.exports
  # being used in node.js
  if global.jasmine?
    install.call(global, require('underscore'), global.jasmine)
  else
    console.error warningMsg
else
  # being used from the browser
  if @jasmine? and @_?
    install.call(@, @_, @jasmine)
  else
    console.error warningMsg
