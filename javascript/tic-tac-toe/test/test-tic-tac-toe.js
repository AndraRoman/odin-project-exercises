/*jslint indent: 2*/
/*global suite, suiteSetup, setup, test*/

var assert = require('assert'),
  Browser = require('zombie'),
  browser = new Browser({site: 'file://'}),
  tileSelector = function (x, y) {
    'use strict';
    return '.row:nth-child(' + String(y + 1) + ') .tile:nth-child(' + String(x + 1) + ')';
  },
  clickTile = function (browser, x, y) {
    'use strict';
    browser.fire(browser.querySelector(tileSelector(x, y)), 'click');
  };

suite('Load page:', function () {
  'use strict';

  suiteSetup(function (done) {
    browser.visit(process.cwd() + '/app/tic-tac-toe.html', done);
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

  suite('Mechanics:', function () {

    setup(function (done) {
      browser.visit(process.cwd() + '/app/tic-tac-toe.html', done);
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

  suite('End of game:', function () {
    setup(function (done) {
      browser.visit(process.cwd() + '/app/tic-tac-toe.html', done);
    });

    test('Game not over', function () {
      clickTile(browser, 1, 1);
      browser.assert.elements('.won', 0);
      browser.assert.hasNoClass('#current-player-par', 'hidden');
      browser.assert.hasClass('#winner-par', 'hidden');
    });

// The following tests seem to take time dependent on order - whichever is first runs slower.
    test('Cat\'s game', function () {
      clickTile(browser, 0, 0);
      clickTile(browser, 1, 0);
      clickTile(browser, 1, 1);
      clickTile(browser, 0, 1);
      clickTile(browser, 2, 0);
      clickTile(browser, 0, 2);
      clickTile(browser, 1, 2);
      clickTile(browser, 2, 2);
      clickTile(browser, 2, 1);
      browser.assert.elements('.tile', 0); // should be frozen
      browser.assert.elements('.won', 0);
      browser.assert.hasClass('#current-player-par', 'hidden');
      browser.assert.hasNoClass('#winner-par', 'hidden');
      assert.equal('nobody', browser.text('#winner'));
    });

    test('Win for X', function () {
      clickTile(browser, 0, 0);
      clickTile(browser, 0, 1);
      clickTile(browser, 1, 1);
      clickTile(browser, 1, 0);
      clickTile(browser, 2, 2);
      browser.assert.elements('.tile', 0);
      browser.assert.elements('.won.x', 3);
      browser.assert.hasClass('#current-player-par', 'hidden');
      browser.assert.hasNoClass('#winner-par', 'hidden');
      assert.equal('x', browser.text('#winner'));
    });

    test('Win for O', function () {
      clickTile(browser, 2, 0);
      clickTile(browser, 0, 0);
      clickTile(browser, 0, 1);
      clickTile(browser, 1, 1);
      clickTile(browser, 1, 0);
      clickTile(browser, 2, 2);
      browser.assert.elements('.tile', 0);
      browser.assert.elements('.won.o', 3);
      browser.assert.hasClass('#current-player-par', 'hidden');
      browser.assert.hasNoClass('#winner-par', 'hidden');
      assert.equal('o', browser.text('#winner'));
    });
  });
});
