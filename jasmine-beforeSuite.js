//
// jasmine-beforeSuite - 0.1.0
//
// A plugin for the Jasmine behavior-driven Javascript testing framework that
// adds beforeSuite and afterSuite global setup functions.
//
// Works in both node.js and a browser environment.
//
// Requires jasmine.js and underscore.js.
//
// @author Joe Vennix
// @copyright Rapid7 2014
// @see https://github.com/jvennix-r7/jasmine-beforeSuite
//
// Released under the MIT License.
//

(function() {
  var context, install, jasmine;

  install = function(_, jasmine) {
    var fnHasNoArgs;
    fnHasNoArgs = function(fn) {
      var fnStr;
      fnStr = fn.toString();
      return _.isEmpty(fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(/([^\s,]+)/g));
    };
    this.beforeSuite = function(fn, opts) {
      var parts, ran, suite, tmpFn, wrappedFn;
      if (opts == null) {
        opts = {};
      }
      if (opts.each == null) {
        opts.each = false;
      }
      suite = jasmine.getEnv().currentSuite;
      ran = false;
      wrappedFn = fnHasNoArgs(fn) ? function() {
        if (opts.each) {
          return fn();
        } else {
          if (!ran) {
            fn();
          }
          return ran = true;
        }
      } : function(done) {
        if (opts.each) {
          return fn(done);
        } else {
          if (ran) {
            setTimeout(done);
          } else {
            fn(done);
          }
          return ran = true;
        }
      };
      wrappedFn.isBeforeSuite = true;
      beforeEach(wrappedFn);
      tmpFn = suite.before_.shift();
      parts = _.partition(suite.before_, function(beforeFn) {
        return beforeFn.isBeforeSuite != null;
      });
      return suite.before_ = _.flatten([parts[1], tmpFn, parts[0]]);
    };
    this.beforeEachSuite = function(fn) {
      return beforeSuite.call(this, fn, {
        each: true
      });
    };
    this.afterSuite = function(fn) {
      var suite;
      suite = jasmine.getEnv().currentSuite;
      suite.afterSuite_ || (suite.afterSuite_ = []);
      return suite.afterSuite_.push(fn);
    };
    return jasmine.Suite.prototype.finish = _.wrap(jasmine.Suite.prototype.finish, function(finish, cb) {
      _.each(this.afterSuite_, function(fn) {
        return fn();
      });
      return finish.call(this, cb);
    });
  };

  context = (typeof window === "object" && window) || (typeof global === "object" && global) || this;

  jasmine = context.jasmine || require("jasmine");

  if (jasmine == null) {
    console.error("jasmine-beforeSuite: Jasmine must be required first. Aborting.");
  } else {
    install.call(context, context._ || require("underscore"), jasmine);
  }

}).call(this);
