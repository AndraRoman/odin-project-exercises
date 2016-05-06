/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {

  width: 3,

  utilities: {
    Point: function (x, y) {
      'use strict';
      var self = this;
      this.equals = function(other) {
        return (other.x === x) && (other.y === y);
      };
      this.x = x; this.y = y;
      this.memberOf = function(arr) {
        return arr.reduce(function(a, b) { return a || self.equals(b); }, false);
      };
      this.addToSet = function(arr) {
        if (self.memberOf(arr)) {
          return arr;
        } else {
          return arr.concat(self);
        }
      };
    },
    available: function(tile) {
      'use strict';
      var result = tile.jquery && tile.attr('class').split(' ').length === 1;
      return result;
    },
    not: function(x) {'use strict'; return !x; },
    boolToPlayer: function(b) { 'use strict'; return b ? 'x' : 'o'; },
    getTileCoords: function(tile) {
      'use strict';
      var x = tile.index(),
          y = tile.parent().index(),
          p = new this.Point(x, y);
      return p;
    },
    draw: function(elt, symbol) {
      'use strict';
      var board = $(elt);
      return function(points) {
        var i, p;
        for (i = 0; i < points.length; i += 1) {
          p = points[i];
          board.find(`.row:eq(${p.y})`).find(`.tile:eq(${p.x})`).addClass(symbol);
        }
      };
    }
  },

  newBoard: function (boardElt) {
    'use strict';
    var x,
      y,
      row;
    for (x = 0; x < this.width; x += 1) {
      row = $('<div/>').addClass('row'); // handy shortcut!
      boardElt.append(row);
      for (y = 0; y < this.width; y += 1) {
        row.append($('<div/>').addClass('tile'));
      }
    }
  },

  run: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    this.newBoard(boardElt);
    $('.row').css('height', String(100.0 / this.width) + '%');
    $('.tile').css('width', String(100.0 / this.width) + '%');
    this.play(boardElt);
  },

  play: function (boardElt) {
    'use strict';
    var utils = this.utilities,
      rawLastTileClicked = boardElt.asEventStream('click')
        .map(function(event) { return utils.getTileCoords($(event.target)); })
        .toProperty(),
      allTilesClicked = rawLastTileClicked
        .scan([], function(arr, point) {
          return point.addToSet(arr); })
        .skipDuplicates(function(arr1, arr2) {
          var newPoint = arr2[arr2.length - 1];
          return arr1.length > 0 && newPoint.memberOf(arr1);
          }).filter(function(arr) { return arr.length > 0; }),
      lastTileMarked = allTilesClicked.map(function(arr) { return arr[arr.length - 1]; }),
      oddTurn = lastTileMarked.scan(true, utils.not),
      tilesOdd = lastTileMarked.filter(oddTurn)
        .scan([], function(arr, obj) { return arr.concat([obj]); }),
      tilesEven = lastTileMarked.filter(oddTurn.not())
        .scan([], function(arr, obj) { return arr.concat([obj]); });

    oddTurn.map(utils.boolToPlayer).assign($('#current-player'), 'text');
    tilesOdd.onValue(utils.draw(boardElt, 'o'));
    tilesEven.onValue(utils.draw(boardElt, 'x'));
  }
};

if (typeof (module) !== 'undefined' && typeof (module.exports) !== 'undefined') {
  module.exports = {
    utils: ticTacToe.utilities
  };
}
