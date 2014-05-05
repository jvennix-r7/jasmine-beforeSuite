require('../src/before_suite') unless @beforeSuite?
_ = require('underscore') unless @_?

describe 'afterSuite', ->

  x = null

  describe 'a Jasmine suite with an afterSuite -> x=1', ->

    afterSuite -> x = 1

    it 'sets x to null', -> expect(x).toEqual(null)

    describe 'when called in a nested suite', ->

      it 'sets x to null', -> expect(x).toEqual(null)

      it 'sets x to null', -> expect(x).toEqual(null)

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

    # PENDING: MAKING ASYNC SPECS WORK
    # describe 'when afterSuite is given an asynchronous function -> x=3', ->

    #   afterSuite (done) ->
    #     setTimeout((-> x = 3; done()), 10)

    #   it 'sets x to 2', -> expect(x).toEqual(2)

    # describe 'when in the next suite', ->

    #   it 'sets x to 3', -> expect(x).toEqual(3)

    #   it 'sets x to 3', -> expect(x).toEqual(3)

  describe 'a Jasmine suite', ->

    y = null

    it 'sets y to null', -> expect(y).toEqual(null)

    describe 'with an afterSuite -> y=2 before an afterEach -> y=1', ->

      afterSuite -> y = 2

      afterEach -> y = 1

      it 'sets y to null', -> expect(y).toEqual(null)

    describe 'in the next suite', ->

      it 'sets y to 2', -> expect(y).toEqual(2)

  describe 'a Jasmine suite', ->

    z = null

    it 'sets z to null', -> expect(z).toEqual(null)

    describe 'with an afterSuite -> z=2 and an afterSuite -> z=3', ->

      afterSuite -> z = 2

      afterSuite -> z = 3

      it 'sets z to null', -> expect(z).toEqual(null)

    describe 'in the next suite', ->

      it 'sets z to 3', -> expect(z).toEqual(3)
