var assert = require('chai').assert,
  Browser = require('zombie');

describe('calculator page loads', function() {
  before(function(done) {
    this.browser = new Browser({site: 'file://'});
    this.browser.visit('file:///home/douglass/code/github/the-odin-project-exercises/javascript/calculator/app/calculator.html', done);
  });

  it('loads page', function() {
    assert.ok(this.browser.success);
    assert.equal(this.browser.text('h1'), 'Calculator');
  });

  it('creates keys', function() {
    assert.equal(this.browser.text('#key-1'), '1');
    assert.equal(this.browser.text('#key-CLR'), 'CLR');
    assert.equal(this.browser.body.querySelectorAll('.key').length, 16);
  });

  it('displays nothing on screen', function() {
    assert.equal(this.browser.text('#display'), '');
  });

});
