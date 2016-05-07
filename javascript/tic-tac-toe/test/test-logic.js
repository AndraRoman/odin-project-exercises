/*jslint indent: 2*/
/*global suite, suiteSetup, setup, test*/

var assert = require('chai').assert,
  ttt = require('../app/scripts/tic-tac-toe.js').utils;

suite('Vector:', function() {

  setup(function () {
    this.p = new ttt.Vector(3, 5);
    this.q = new ttt.Vector(3, 6);
    this.r = new ttt.Vector(2, 5);
    this.newVector = new ttt.Vector(3, 5);
  });

  test('equals gives true if points are equivalent', function () {
    assert.isTrue(this.p.equals(this.newVector));
  });

  test('equals gives false if points are equivalent', function () {
    assert.isFalse(this.p.equals(this.q));
    assert.isFalse(this.p.equals(this.r));
  });

  test('memberOf gives true if array contains equivalent point', function () {
    assert.isTrue(this.p.memberOf([this.q, this.p, this.r]));
  });

  test('memberOf gives false if array does not contain equivalent point', function () {
    assert.isFalse(this.p.memberOf([]));
    assert.isFalse(this.p.memberOf([this.q, this.r]));
  });

  test('addToSet returns array with point added when not already present', function () {
    var list = [this.r, this.q];
      newList = this.newVector.addToSet(list);
    assert.equal(3, newList.length)
  });

  test('addToSet returns unchanged array when point already present', function () {
    var list = [this.r, this.p, this.q],
      newList = this.newVector.addToSet(list);
    assert.equal(3, newList.length)
  });

  test('add vectors', function () {
    var expected = new ttt.Vector(6, 7),
      diff = new ttt.Vector(3, 2),
      result = this.p.add(diff);
    assert.isTrue(expected.equals(result));
  });

  test('negate vector', function () {
    var expected = new ttt.Vector(-3, -5);
      result = this.p.negate();
    assert.isTrue(expected.equals(result));
  });

});

suite('Win detection:', function () {

  test('Row', function () {
    // TODO
  });

  test('Column', function () {
    // TODO
  });

  test('Diagonal', function () {
    // TODO
  });

  test('No win', function () {
    // TODO
  });

});
