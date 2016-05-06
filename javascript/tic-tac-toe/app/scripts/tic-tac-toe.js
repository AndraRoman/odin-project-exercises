/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $*/

var ticTacToe = {

  utilities: {
    Point: function (x, y) {
      'use strict';
      this.x = x; this.y = y;
    },
    available: function(tile) {
      'use strict';
      var result = tile.jquery && tile.attr('class').split(' ').length === 1;
      return result;
    },
    not: function(x) {'use strict'; return !x; },
    boolToPlayer: function(x) { 'use strict'; return x ? 'x' : 'o'; },
    getTileCoords: function(tile) {
      'use strict';
      var x = tile.index(),
          y = tile.parent().index(),
          p = new this.Point(x, y);
      return p;
    },
    draw: function(elt, symbol) {
      'use strict';
      var board = $(elt),
        i,
        p;
      return function(points) {
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
    for (x = 0; x < 3; x += 1) {
      row = $('<div/>').addClass('row'); // handy shortcut!
      boardElt.append(row);
      for (y = 0; y < 3; y += 1) {
        row.append($('<div/>').addClass('tile'));
      }
    }
  },

  run: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    this.newBoard(boardElt);
    this.play(boardElt);
  },

  play: function (boardElt) {
    'use strict';
    var utilities = this.utilities,
      lastTileClicked = boardElt.asEventStream('click').map(function(event) {
        var tile = $(event.target);
        if (utilities.available(tile)) {
          return utilities.getTileCoords(tile);
        }
      }).toProperty().filter(function(v) {
          return v !== undefined;
        }
      ),
      oddTurn = lastTileClicked.scan(true, utilities.not),
      tilesOdd = lastTileClicked.filter(oddTurn)
        .scan([], function(arr, obj) { return arr.concat([obj]); }),
      tilesEven = lastTileClicked.filter(oddTurn.map(utilities.not))
        .scan([], function(arr, obj) { return arr.concat([obj]); });

    oddTurn.map(utilities.boolToPlayer).assign($('#current-player'), 'text');
    tilesOdd.onValue(utilities.draw(boardElt, 'o'));
    tilesEven.onValue(utilities.draw(boardElt, 'x'));
  }
};

$(ticTacToe.run($('#board')));
