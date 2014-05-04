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
#
# Released under the MIT License.
#


install = (_, jasmine) ->

  # returns true if passed +fn+ has one or more arguments
  fnHasNoArgs = (fn) ->
    fnStr = fn.toString()
    _.isEmpty(fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(/([^\s,]+)/g))

  # returns true if the recently executed spec was the last one in its suite
  isLastJasmineSpecInSuite = ->
    last = _.last(jasmine.getEnv().currentSpec?.suite?.specs_)
    if last then last.id == jasmine.getEnv().currentSpec?.id else false

  @beforeSuite = (fn) ->

    # Similar to _.once, ensure fn() is only called once, and make
    # sure to pass the done() async callback down as necessary.
    do ->
      ran = false
      if fnHasNoArgs(fn)
        beforeEach ->
          fn() unless ran
          ran = true
      else
        beforeEach (done) ->
          fn(done) unless ran
          ran = true

  @afterSuite = (fn) ->
    # We ensure that the after fn is only run after the last spec in its suite
    do ->
      if fnHasNoArgs(fn)
        afterEach ->
          fn() if isLastJasmineSpecInSuite()
      else
        afterEach (done) ->
          fn(done) if isLastJasmineSpecInSuite()

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
