/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {
  newTile: function (x, y) {
    'use strict';
    var tile = $(`<div class="tile", id="${x}-${y}"></div>`);
    return tile;
  },

  available: function(tile) {
    var result = tile.jquery && tile.text().length == 0;
    return result;
  },

  newBoard: function (boardElt) {
    'use strict';
    var x,
      y,
      tile,
      row,
      tileMatrix = [];
    for (x = 0; x < 3; x += 1) {
      row = [];
      for (y = 0; y < 3; y += 1) {
        tile = this.newTile(x, y);
        row.push(tile);
        boardElt.append(tile);
      }
      tileMatrix.push(row);
    }
    return tileMatrix;
  },

  play: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    var tileMatrix = this.newBoard(boardElt),
      available = this.available,
      nand = function(a, b) {
        return !(a && b);
      },
      lastTileClicked = boardElt.asEventStream('click').map(function(event) {
        return $(event.target);
      }).toProperty("").filter(available),
      toggle = function(x) { return !x},
      boolToPlayer = function(x) { return x ? 'x' : 'o' },
      oddTurn = lastTileClicked.scan(false, toggle),
      currentPlayer = oddTurn.map(boolToPlayer);
    currentPlayer.assign($('#current-player'), 'text');
    lastTileClicked.onValue(function(v) {
      var alternator = lastTileClicked.scan(false, toggle),
        nanded = Bacon.combineWith(nand, alternator, oddTurn);
      nanded.take(1).map(boolToPlayer).assign($(v), 'text'); // nanded.take(n) creates a stream that takes at most n values from nanded and then ends
    });
  }
};

$(ticTacToe.play($('#board')));
