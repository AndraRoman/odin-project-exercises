/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {
  newTile: function (x, y) {
    'use strict';
    var tile = $(`<div class="tile", id="${x}-${y}"></div>`);
    return tile;
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
    $('#board').removeClass('js-off');
    var tileMatrix = this.newBoard(boardElt);
    // TODO gameplay
  }
};

$(ticTacToe.play($('#board')));
