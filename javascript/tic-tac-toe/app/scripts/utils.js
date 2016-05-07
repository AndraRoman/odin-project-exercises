/*jslint indent: 2*/
/*global $*/

var utils = {

  width: 3,

  ident: function (val) { 'use strict'; return val; },

  getTileCoords: function (tile) {
    'use strict';
    var x = tile.index(),
      y = tile.parent().index();
    return new this.Vector(x, y);
  },

  findTile: function findTile(board, point) {
    'use strict';
    return board.find('.row:eq(' + point.y + ')').find('.tile:eq(' + point.x + ')');
  },

  draw: function (elt, symbol) {
    'use strict';
    var board = $(elt),
      self = this;
    return function (points) {
      var i;
      for (i = 0; i < points.length; i += 1) {
        self.findTile(board, points[i]).addClass(symbol);
      }
    };
  },

  Vector: function Vector(x, y) {
    'use strict';
    var self = this;
    this.x = x;
    this.y = y;

    this.equals = function (other) { return (other.x === x) && (other.y === y); };

    this.memberOf = function (arr) {
      return arr.reduce(function (a, b) { return a || self.equals(b); }, false);
    };

    this.addToSet = function (arr) {
      if (self.memberOf(arr)) { return arr; }
      return arr.concat(self);
    };

    this.add = function (diff) { return new Vector(x + diff.x, y + diff.y); };

    this.negate = function () { return new Vector(-x, -y); };

    this.wins = function (arr) {
      var nextPoint = arr[0],
        rest = arr.slice(1),
        diff,
        distance,
        lastPoint;
      if (arr.length < 1) { return false; }
      diff = this.negate().add(nextPoint);
      distance = Math.max(Math.abs(diff.x), Math.abs(diff.y));

      if (distance > 1 && diff.x % distance === 0 && diff.y % distance === 0) {
        diff.x = diff.x / distance;
        diff.y = diff.y / distance;
      }

      // TODO don't be specific to width of 3
      lastPoint = [nextPoint.add(diff), nextPoint.add(diff.negate()), this.add(diff.negate()), this.add(diff)]
        .filter(function (point) { return (point.memberOf(rest)); })[0];
      if (lastPoint) { return [this, nextPoint, lastPoint]; }
      return this.wins(rest);
    };
  },
};

if (typeof module !== 'undefined' && typeof (module.exports) !== 'undefined') {
  module.exports = {
    utils: utils
  };
}
