require('../src/before_suite') unless @beforeSuite?
_ = require('underscore') unless @_?

describe 'beforeSuite', ->

  describe 'a Jasmine suite with a beforeSuite that increments x', ->

    x = 0

    beforeSuite ->
      x++

    it 'sets x to 1', ->
      expect(x).toEqual(1)

    it 'still sets x to 1', ->
      expect(x).toEqual(1)

    it 'still sets x to 1', ->
      expect(x).toEqual(1)

    describe 'when nesting a spec with another beforeSuite that decrements x', ->

      beforeSuite ->
        x--

      it 'sets x to 0', ->
        expect(x).toEqual(0)

      it 'still sets x to 0', ->
        expect(x).toEqual(0)

    describe 'when nesting another spec', ->

      it 'sets x to 0', ->
        expect(x).toEqual(0)

      it 'still sets x to 0', ->
        expect(x).toEqual(0)

    describe 'when used in an asynchronous function', ->

      beforeSuite (done) ->
        setTimeout((-> x = 5; done()), 10)

      it 'sets x to 5', ->
        expect(x).toEqual(5)
