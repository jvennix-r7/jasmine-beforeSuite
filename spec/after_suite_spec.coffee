require('../src/before_suite') unless @beforeSuite?
_ = require('underscore') unless @_?

describe 'afterSuite', ->

  x = 0

  describe 'when called in a nested suite', ->

    afterSuite -> x = 1

    it 'sets x to 0', -> expect(x).toEqual(0)

    it 'sets x to 0', -> expect(x).toEqual(0)

    it 'sets x to 0', -> expect(x).toEqual(0)

  describe 'when in the next suite', ->

    it 'sets x to 1', -> expect(x).toEqual(1)

    describe 'when called in a further nested suite', ->

      afterSuite -> x = 2

      it 'sets x to 1', -> expect(x).toEqual(1)

      it 'sets x to 1', -> expect(x).toEqual(1)

    describe 'when in the next suite', ->

      it 'sets x to 2', -> expect(x).toEqual(2)

    it 'sets x to 2', -> expect(x).toEqual(2)

    it 'sets x to 2', -> expect(x).toEqual(2)

  describe 'when called asynchronously', ->

    afterSuite (done) ->
      setTimeout((-> x=3; done()), 10)

    it 'sets x to 2', -> expect(x).toEqual(2)

  describe 'when in the next suite', ->

    it 'sets x to 3', -> expect(x).toEqual(3)
