/*jslint indent: 2*/
/*global suite, test*/

var assert = require('chai').assert;
var ops = require("../app/scripts/operations.js");

suite("Basic ops", function () {
  'use strict';

  test("add", function () {
    assert.equal(5, ops.add(4, 1));
  });

  test("subtract", function () {
    assert.equal(-5, ops.subtract(5, 10));
  });

  test("multiply", function () {
    assert.equal(42, ops.multiply(6, 7));
  });

  test("divide", function () {
    assert.equal(3, ops.divide(15, 5));
  });

  test("add with symbol", function () {
    assert.equal(-3, ops.toOperator("+")(-4, 1));
  });

  test("subtract with symbol", function () {
    assert.equal(-3, ops.toOperator("-")(1, 4));
  });

  test("multiply with symbol", function () {
    assert.equal(10, ops.toOperator("*")(-5, -2));
  });

  test("divide with symbol", function () {
    assert.equal(-4, ops.toOperator("/")(8, -2));
  });
});

suite("Miscellaneous", function () {
  'use strict';

  test("is_operator", function () {
    assert(ops.is_operator("."));
    assert(ops.is_operator("-"));
    assert(ops.is_operator("("));
    assert.isFalse(ops.is_operator("1"));
  });

  test("format", function () {
    assert.equal("abcde", ops.format(["a", "b", "cde"]));
  });

  test("add_digit", function () {
    assert.equal(134, ops.add_digit(13, "4"));
    assert.equal(-102, ops.add_digit(-10, "2"));
  });
});

suite("Parsing", function () {
  'use strict';

  suite("higher_precedence", function () {
    test("arg 1 has higher precedence than arg 2", function () {
      assert(ops.higher_precedence("*", "-"));
      assert(ops.higher_precedence("/", "+"));
    });

    test("arg 2 has higher precedence than arg 1", function () {
      assert.isFalse(ops.higher_precedence("-", "/"));
      assert.isFalse(ops.higher_precedence("+", "*"));
    });

    test("both arguments have same precedence", function () {
      assert.isFalse(ops.higher_precedence("-", "+"));
      assert.isFalse(ops.higher_precedence("/", "*"));
    });
  });

  suite("to_rpn", function () {
    test("just one operator", function () {
      var input = [5, "+", 10],
        expected = [5, 10, "+"];
      assert.deepEqual(expected, ops.to_rpn(input));
    });

    test("two precedence levels", function () {
      var input = [5, "+", 6, "/", 2, "-", 1, "*", 0],
        expected = [5, 6, 2, "/", 1, 0, "*", "-", "+"];
      assert.deepEqual(expected, ops.to_rpn(input));
    });
  });

  test("eval_rpn", function () {
    var input = [5, 6, 2, "/", 1, 0, "*", "-", "+"];
    assert.equal(8, ops.eval_rpn(input));
  });

  test("evaluate", function () {
    var input = [5, "+", 6, "/", 2, "-", 1, "*", 0];
    assert.equal(8, ops.evaluate(input));
  });
});

suite("Test process_input", function () {
  'use strict';

  test("clear", function () {
    var history = [5, "+", 6, "/", 2, "-", 1, "*", 0];
    ops.process_input(history, "CLR");
    assert.equal(0, history.length);
  });

  test("equals", function () {
    var history = [5, "+", 6, "/", 2, "-", 1, "*", 0];
    ops.process_input(history, "=");
    assert.deepEqual([8], history);
  });

  test("initial operator", function () {
    var history = [];
    ops.process_input(history, "+");
    assert.equal(0, history.length);
  });

  test("operator following operator", function () {
    var history = [-10, "+"];
    ops.process_input(history, "/");
    assert.deepEqual([-10, "+"], history);
  });

  test("operator following number", function () {
    var history = [-10];
    ops.process_input(history, "+");
    assert.deepEqual([-10, "+"], history);
  });

  test("initial number", function () {
    var history = [];
    ops.process_input(history, "9");
    assert.deepEqual([9], history);
  });

  test("number following operator", function () {
    var history = [-10, "+"];
    ops.process_input(history, "9");
    assert.deepEqual([-10, "+", 9], history);
  });

  test("number following number", function () {
    var history = [-10];
    ops.process_input(history, "9");
    assert.deepEqual([-109], history);
  });

});
