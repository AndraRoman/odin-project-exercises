/*jslint indent: 2*/
/*global suite, suiteSetup, setup, test*/

var assert = require('assert'),
  Browser = require('zombie'),
  tileSelector = function (x, y) {
    'use strict';
    return `.row:nth-child(${y + 1}) .tile:nth-child(${x + 1})`;
  },
  clickTile = function (browser, x, y) {
    'use strict';
    browser.fire(browser.querySelector(tileSelector(x, y)), 'click');
  };

suite('Load page:', function () {
  'use strict';
  var browser;

  suiteSetup(function (done) {
    browser = new Browser({site: 'file://'});
    browser.visit('file://' + process.cwd() + '/app/tic-tac-toe.html', done);
  });

  test('Successfully loads page', function () {
    assert.ok(browser.success);
  });

  test('Board is present, with nine tiles', function () {
    browser.assert.element('#board');
    browser.assert.elements('.tile', 9);
  });

  test('No O or X to start with', function () {
    browser.assert.elements('.x', 0);
    browser.assert.elements('.o', 0);
  });

  test('First player is X', function () {
    assert.equal('x', browser.text('#current-player'));
  });

});

suite('Gameplay:', function () {
  'use strict';
  var browser;

  setup(function (done) {
    browser = new Browser({site: 'file://'});
    browser.visit('file://' + process.cwd() + '/app/tic-tac-toe.html', done);
  });

  test('Clicking an empty tile marks it with current player', function () {
    clickTile(browser, 0, 0);
    browser.assert.element('.x');
    browser.assert.hasClass(tileSelector(0, 0), 'x');
    browser.assert.hasNoClass(tileSelector(0, 0), 'o');

    clickTile(browser, 1, 1);
    browser.assert.element('.o');
    browser.assert.hasClass(tileSelector(1, 1), 'o');
    browser.assert.hasNoClass(tileSelector(1, 1), 'x');
  });

  test('Clicking an empty tile toggles current player', function () {
    clickTile(browser, 0, 0);
    assert.equal('o', browser.text('#current-player'));

    clickTile(browser, 1, 1);
    assert.equal('x', browser.text('#current-player'));
  });

  test('Clicking an empty tile does not change previously marked tile', function () {
    clickTile(browser, 0, 0);
    clickTile(browser, 1, 1);
    browser.assert.hasClass(tileSelector(0, 0), 'x');
    browser.assert.hasNoClass(tileSelector(0, 0), 'o');

    clickTile(browser, 2, 2);
    browser.assert.hasClass(tileSelector(1, 1), 'o');
    browser.assert.hasNoClass(tileSelector(1, 1), 'x');
  });

  test('Clicking a marked tile does not change its mark', function () {
    clickTile(browser, 0, 0);
    clickTile(browser, 0, 0);
    browser.assert.element('.x');
    browser.assert.hasClass(tileSelector(0, 0), 'x');
    browser.assert.hasNoClass(tileSelector(0, 0), 'o');

    clickTile(browser, 1, 1);
    clickTile(browser, 1, 1);
    browser.assert.element('.o');
    browser.assert.hasClass(tileSelector(1, 1), 'o');
    browser.assert.hasNoClass(tileSelector(1, 1), 'x');
  });

  test('Clicking a marked tile does not toggle current player', function () {
    clickTile(browser, 0, 0);
    clickTile(browser, 0, 0);
    assert.equal('o', browser.text('#current-player'));

    clickTile(browser, 1, 1);
    clickTile(browser, 1, 1);
    assert.equal('x', browser.text('#current-player'));
  });
});
