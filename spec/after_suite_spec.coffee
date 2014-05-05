require('../src/before_suite') unless @beforeSuite?
_ = require('underscore') unless @_?

describe 'afterSuite', ->

  describe 'a Jasmine suite with an afterSuite -> x=1', ->

    x = null

    afterSuite -> x = 1

    it 'sets x to null', -> expect(x).toEqual(null)

    describe 'when called in a nested suite', ->

      it 'sets x to 1', -> expect(x).toEqual(1)

      it 'sets x to 1', -> expect(x).toEqual(1)

    describe 'when in the next suite', ->

      it 'sets x to 1', -> expect(x).toEqual(1)

      it 'sets x to 1', -> expect(x).toEqual(1)

      describe 'when nesting a spec with another afterSuite -> x=2', ->

        afterSuite -> x = 2

        it 'sets x to 1', -> expect(x).toEqual(1)

        it 'sets x to 1', -> expect(x).toEqual(1)

      describe 'when in the next suite', ->

        it 'sets x to 2', -> expect(x).toEqual(2)

      it 'sets x to 2', -> expect(x).toEqual(2)

      it 'sets x to 2', -> expect(x).toEqual(2)

    describe 'when afterSuite is given an asynchronous function -> x=3', ->

      afterSuite (done) ->
        setTimeout((-> x = 3; done()), 10)

      it 'sets x to 3', -> expect(x).toEqual(3)

      it 'sets x to 3', -> expect(x).toEqual(3)

  describe 'a Jasmine suite', ->

    x = null

    it 'sets x to null', -> expect(x).toEqual(null)

    describe 'with an afterSuite -> x=2 before an afterEach -> x=1', ->

      afterSuite -> x = 2

      afterEach -> x = 1

      it 'sets x to null', -> expect(x).toEqual(null)

    describe 'in the next suite', ->

      it 'sets x to 2', -> expect(x).toEqual(2)
