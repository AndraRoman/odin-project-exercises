/*jslint es6: true, white: true, browser: true, for: true, this: true*/
/*global $ utils*/

var ticTacToe = {

  newBoard: function (boardElt) {
    'use strict';
    var x, y, row;
    for (x = 0; x < utils.width; x += 1) {
      row = $('<div/>').addClass('row'); // handy shortcut!
      boardElt.append(row);
      for (y = 0; y < utils.width; y += 1) {
        row.append($('<div/>').addClass('tile'));
      }
    }
  },

  run: function (boardElt) {
    'use strict';
    boardElt.removeClass('js-off');
    this.newBoard(boardElt);
    $('.row').css('height', String(100.0 / utils.width) + '%');
    $('.tile').css('width', String(100.0 / utils.width) + '%');
    this.play(boardElt);
  },

  play: function (boardElt) {
    'use strict';
    var checkWin,
      gameWon,
      boardFull,
      allTilesClicked = boardElt.asEventStream('click')
        .map(function (event) { return utils.getTileCoords($(event.target)); }).toProperty()
        .scan([], function (arr, point) { return point.addToSet(arr); })
        .skipDuplicates(function (arr1, arr2) { return arr1.length === arr2.length; }),
      lastTileMarked = allTilesClicked.skip(1).map(function (arr) { return arr[arr.length - 1]; }),
      oddTurn = lastTileMarked.scan(true, function (x) { return !x; }),
      tilesOdd = lastTileMarked.filter(oddTurn)
        .scan([], function (arr, obj) { return arr.concat([obj]); }),
      tilesEven = lastTileMarked.filter(oddTurn.not())
        .scan([], function (arr, obj) { return arr.concat([obj]); });

    oddTurn.map(function (b) { return b ? 'x' : 'o'; }).assign($('#current-player'), 'text');
    tilesOdd.onValue(utils.draw(boardElt, 'o'));
    tilesEven.onValue(utils.draw(boardElt, 'x'));

    checkWin = function (arr) {
       var point = arr[arr.length - 1],
        rest = arr.slice(0, arr.length - 1),
        winningTiles;
      if (arr.length < 1) { return false; }
      winningTiles = point.wins(rest);
      if (winningTiles.length > 0) { return winningTiles; } else { return false; }
    };

    boardFull = allTilesClicked.map(function (arr) { return arr.length >= utils.width * utils.width; })
      .skipDuplicates().skip(1).startWith(false);

    gameWon = tilesOdd
      .combine(tilesEven, function (a, b) { return checkWin(a) || checkWin(b); }); 

    gameWon.filter(utils.ident).onValue(function (arr) {
        var i, color = function (point) { utils.findTile(boardElt, point).addClass('won'); };
        for (i = 0; i < arr.length; i += 1) {
          arr.forEach(color);
        }
      });

    gameWon.or(boardFull).filter(utils.ident).onValue(function () {
      $('p:first-of-type').css('visibility', 'hidden');
      $('.tile').addClass('tile-frozen').removeClass('tile');
    });
  }
};

$(ticTacToe.run($('#board')));
