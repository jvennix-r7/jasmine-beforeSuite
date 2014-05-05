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
    parts = _.partition(suite.before_, (beforeFn) -> beforeFn.isBeforeSuite?)
    suite.before_ = _.flatten [parts[1], tmpFn, parts[0]]

  @afterSuite = (fn) ->
    # We ensure that the after fn is only run after the last spec in its suite
    suite = jasmine.getEnv().currentSuite
    suite.afterSuite_ ||= []
    suite.afterSuite_.push(fn)

  finish = jasmine.Suite.prototype.finish
  jasmine.Suite.prototype.finish = (cb) ->
    _.each(@afterSuite_, (fn) -> fn())
    finish.call @, cb

context = (typeof window == "object" && window) || (typeof global == "object" && global) || @
jasmine = context.jasmine || require("jasmine")

unless jasmine?
  # Displayed if the user forgets to include jasmine in the environment
  console.error "jasmine-beforeSuite: Jasmine must be required first. Aborting."
else
  install.call(context, context._ || require("underscore"), jasmine)
