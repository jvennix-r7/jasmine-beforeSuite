(function() {
  var install, warningMsg;

  install = function(_, jasmine) {
    var fnHasNoArgs, isLastJasmineSpecInSuite;
    fnHasNoArgs = function(fn) {
      var fnStr;
      fnStr = fn.toString();
      return _.isEmpty(fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(/([^\s,]+)/g));
    };
    isLastJasmineSpecInSuite = function() {
      var last, _ref, _ref1, _ref2;
      last = _.last((_ref = jasmine.getEnv().currentSpec) != null ? (_ref1 = _ref.suite) != null ? _ref1.specs_ : void 0 : void 0);
      if (last) {
        return last.id === ((_ref2 = jasmine.getEnv().currentSpec) != null ? _ref2.id : void 0);
      } else {
        return false;
      }
    };
    this.beforeSuite = function(fn) {
      return (function() {
        var ran;
        ran = false;
        if (fnHasNoArgs(fn)) {
          return beforeEach(function() {
            if (!ran) {
              fn();
            }
            return ran = true;
          });
        } else {
          return beforeEach(function(done) {
            if (!ran) {
              fn(done);
            }
            return ran = true;
          });
        }
      })();
    };
    return this.afterSuite = function(fn) {
      return (function() {
        if (fnHasNoArgs(fn)) {
          return afterEach(function() {
            if (isLastJasmineSpecInSuite()) {
              return fn();
            }
          });
        } else {
          return afterEach(function(done) {
            if (isLastJasmineSpecInSuite()) {
              return fn(done);
            }
          });
        }
      })();
    };
  };

  warningMsg = "jasmine-beforeSuite: Jasmine must be required first. Aborting.";

  if (typeof module !== 'undefined' && module.exports) {
    if (global.jasmine != null) {
      install.call(global, require('underscore'), global.jasmine);
    } else {
      console.error(warningMsg);
    }
  } else {
    if ((this.jasmine != null) && (this._ != null)) {
      install.call(this, this._, this.jasmine);
    } else {
      console.error(warningMsg);
    }
  }

}).call(this);
