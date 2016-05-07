/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {

  utilities: {
    width: 3,
    Vector: function Vector(x, y) {
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
      this.add = function(diff) {
        return new Vector(x + diff.x, y + diff.y);
      };
      this.negate = function() {
        return new Vector(-x, -y);
      };
    },
    available: function(tile) {
      'use strict';
      var result = tile.jquery && tile.attr('class').split(' ').length === 1;
      return result;
    },
    not: function(x) {'use strict'; return !x; },
    getTileCoords: function(tile) {
      'use strict';
      var x = tile.index(),
          y = tile.parent().index(),
          p = new this.Vector(x, y);
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
    for (x = 0; x < this.utilities.width; x += 1) {
      row = $('<div/>').addClass('row'); // handy shortcut!
      boardElt.append(row);
      for (y = 0; y < this.utilities.width; y += 1) {
        row.append($('<div/>').addClass('tile'));
      }
    }
  },

  run: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    this.newBoard(boardElt);
    $('.row').css('height', String(100.0 / this.utilities.width) + '%');
    $('.tile').css('width', String(100.0 / this.utilities.width) + '%');
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
          var newVector = arr2[arr2.length - 1];
          return arr1.length > 0 && newVector.memberOf(arr1);
          }),
      lastTileMarked = allTilesClicked.skip(1).map(function(arr) { return arr[arr.length - 1]; }),
      oddTurn = lastTileMarked.scan(true, utils.not),
      tilesOdd = lastTileMarked.filter(oddTurn)
        .scan([], function(arr, obj) { return arr.concat([obj]); }),
      tilesEven = lastTileMarked.filter(oddTurn.not())
        .scan([], function(arr, obj) { return arr.concat([obj]); }),
      catsGame = allTilesClicked.map(function (arr) { return arr.length >= utils.width * utils.width }).skipDuplicates().skip(1);

    oddTurn.map(function (b) { return b ? 'x' : 'o'; }).assign($('#current-player'), 'text');
    tilesOdd.onValue(utils.draw(boardElt, 'o'));
    tilesEven.onValue(utils.draw(boardElt, 'x'));
    catsGame.onValue(function() {
      $('#winner').text("cat's game!");
      $('p:first-of-type').hide();
    });
  }
};

if (typeof (module) !== 'undefined' && typeof (module.exports) !== 'undefined') {
  module.exports = {
    utils: ticTacToe.utilities
  };
}
