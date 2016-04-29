/*jslint indent: 2*/
/*global suite, suiteSetup, setup, test*/

var assert = require('assert'),
  Browser = require('zombie');

suite('Load page', function () {
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

});

suite('Gameplay', function () {
  'use strict';
  var browser;

  setup(function (done) {
    browser = new Browser({site: 'file://'});
    browser.visit('file://' + process.cwd() + '/app/tic-tac-toe.html', done);
  });

});
