require('../src/before_suite') unless @beforeSuite?
_ = require('underscore') unless @_?

describe 'beforeSuite', ->

  describe 'a Jasmine suite with a beforeSuite -> x=1', ->

    x = null

    beforeSuite -> x = 1

    it 'sets x to 1', -> expect(x).toEqual(1)

    it 'sets x to 1', -> expect(x).toEqual(1)

    describe 'when nesting a spec with another beforeSuite -> x=2', ->

      beforeSuite -> x = 2

      it 'sets x to 2', -> expect(x).toEqual(2)

      it 'sets x to 2', -> expect(x).toEqual(2)

    describe 'the next nested spec', ->

      it 'sets x to 2', -> expect(x).toEqual(2)

      it 'sets x to 2', -> expect(x).toEqual(2)

    describe 'when beforeSuite is given an asynchronous function -> x=3', ->

      beforeSuite (done) ->
        setTimeout((-> x = 3; done()), 10)

      it 'sets x to 3', -> expect(x).toEqual(3)

      it 'sets x to 3', -> expect(x).toEqual(3)

  describe 'a Jasmine suite with a beforeSuite -> x=2 after a beforeEach -> x=1', ->

    x = 0

    beforeEach -> x = 1

    beforeSuite -> x = 2

    it 'sets x to 1', -> expect(x).toEqual(1)

    it 'sets x to 1', -> expect(x).toEqual(1)

  describe 'a Jasmine suite with a beforeSuite -> x=2 after a beforeSuite -> x=1', ->

    x = 0

    beforeSuite -> x = 1

    beforeSuite -> x = 2

    it 'sets x to 2', -> expect(x).toEqual(2)

    it 'sets x to 2', -> expect(x).toEqual(2)

  describe 'a Jasmine suite with a beforeSuite -> x=2, beforeSuite -> x=1, and beforeSuite -> x=3', ->

    x = 0

    beforeSuite -> x = 1

    beforeSuite -> x = 2

    beforeSuite -> x = 3

    it 'sets x to 3', -> expect(x).toEqual(3)

    it 'sets x to 3', -> expect(x).toEqual(3)
