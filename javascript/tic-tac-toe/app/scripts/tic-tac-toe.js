/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {
  newTile: function (x, y) {
    'use strict';
    var tile = $(`<div class="tile", id="${x}-${y}"></div>`);
    return tile;
  },

  utilities: {
    available: function(tile) {
      'use strict';
      var result = tile.jquery && tile.attr('class').split(' ').length === 1;
      return result;
    },
    toggle: function(x) {'use strict'; return !x; },
    boolToPlayer: function(x) { 'use strict'; return x ? 'x' : 'o'; }
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

  run: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    this.play(boardElt);
  },

  play: function (boardElt) {
    'use strict';
    var tileMatrix = this.newBoard(boardElt),
      utilities = this.utilities,
      lastTileClicked = boardElt.asEventStream('click').map(function(event) {
        return $(event.target);
      }).toProperty().filter(utilities.available),
      oddTurn = lastTileClicked.scan(true, utilities.toggle);

    oddTurn.map(utilities.boolToPlayer).assign($('#current-player'), 'text');
    lastTileClicked.onValue(function(tile) {
      oddTurn.take(1).onValue(function(parity) {
        var newClass = utilities.boolToPlayer(!parity);
        tile.addClass(newClass);
      });
    });
  }
};

$(ticTacToe.run($('#board')));
