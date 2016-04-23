var assert = require('chai').assert,
  Browser = require('zombie'),
  browser = new Browser({site: 'file://'}),
  clickKey = function(name) { 
    browser.fire(browser.querySelector(`#key-${name}`), "click", function() {});
  };

describe('calculator', function() {

  before(function(done) {
    browser.visit('file:///home/douglass/code/github/the-odin-project-exercises/javascript/calculator/app/calculator.html', done);
  });

  describe('basic rendering', function() {

    it('loads page', function() {
      assert.ok(browser.success);
      assert.equal(browser.text('h1'), 'Calculator');
    });

    it('creates keys', function() {
      assert.equal(browser.text('#key-1'), '1');
      assert.equal(browser.text('#key-CLR'), 'CLR');
      assert.equal(browser.body.querySelectorAll('.key').length, 16);
    });

    it('displays nothing on screen', function() {
      assert.equal(browser.text('#display'), '');
    });

  });

  describe('calculator is interactive', function() {

    beforeEach(function() {
      clickKey('CLR');
    });

    describe('calculator takes user input', function() {

      it('displays the number the user clicks on', function() {
        clickKey('5'); // this times out
        assert.equal(browser.text('#display'), '5');
      });

      it('clears screen', function() {
        clickKey('5'); // but this doesn't!
        clickKey('CLR');
        assert.equal(browser.text('#display'), '');
      });

      it('allows tabbing between keys', function() {
      // TODO
      });

    });

    describe('calculator performs calculations', function() {

      it('adds', function() {
        ['1', '0', '\\+', '2', '3', '\\='].forEach(clickKey); // in CSS need single '\' to escape otherwise invalid character; here we need to escape the '\' instead
        assert.equal(browser.text('#display'), '33');
      });

      it('subtracts', function() {
        ['4', '5', '\\-', '6', '7', '\\='].forEach(clickKey);
        assert.equal(browser.text('#display'), '-22');
      });

      it('multiplies', function() {
        ['8', '\\*', '1', '1', '\\='].forEach(clickKey);
        assert.equal(browser.text('#display'), '88');
      });

      it('divides', function() {
        ['9', '9', '\\/', '3', '\\='].forEach(clickKey);
        assert.equal(browser.text('#display'), '33');
      });

      it('chains operations', function() {
        ['9', '\\+', '8', '\\=', '\\*', '2', '\\='].forEach(clickKey);
        assert.equal(browser.text('#display'), '34');
      });

    });

  });

});
