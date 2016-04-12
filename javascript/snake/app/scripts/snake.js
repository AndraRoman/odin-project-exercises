/*jslint browser: true, es6: true, for: true, white: true*/
/*global $*/

// Setup

function makeSquare(x, y) {
  "use strict";
  var tile = $(`<div class="tile" id="${x}-${y}"></div>`);
  return tile;
}

function makeRow(size, n) {
  "use strict";
  var row = $(`<div class="row"></div>`),
    i,
    tile;
  for (i = 0; i < size; i += 1) {
    tile = makeSquare(i, n);
    row.append(tile);
  }
  return row;
}

function makeBoard(elt, size, walls) {
  "use strict";
  var board = {};
  board.contents = [];

  var i, row, tileArray;
  for (i = 0; i < size; i += 1) {
    row = makeRow(size, i);
    elt.append(row);
    tileArray = row.children().toArray();
    board.contents.push(tileArray);
  }

  board.getTile = function(coords) {
    return this.contents[coords[1]][coords[0]];
  };
  board.getEmptyTile = function() {
    var emptyTiles = flatten(this.contents).filter(function (item) {
      return $(item).attr('class') === 'tile'
    });
    var i = Math.floor(Math.random() * emptyTiles.length);
    var tile = emptyTiles[i];
    return $(tile);
  };

  addWalls(board, walls); // lint: out of scope

  return board;
}

function addWalls(board, wallSet) {
  "use strict";
  var coords, i, tile;
  for (i = 0; i < wallSet.length; i += 1) {
    coords = wallSet[i];
    tile = board.getTile(coords);
    $(tile).addClass('wall'); // not sure why I need the $ here when makeSquare() already should have wrapped it in $
  }
}

// Objects
function setUpGame(game, boardElt) {
  "use strict";
  var walls = makeWallSet(game.size); // lint: out of scope

  game.size = 20;
  game.tick = 0;
  game.score = 0;
  game.unit = [1, 0]; // default to moving right

  game.board = makeBoard(boardElt, game.size, walls);
  game.food = makeFood(game.board); // lint: out of scope
  game.snake = makeSnake(game); // lint: out of scope

  return game;
}

function makeFood(board) {
  "use strict";
  var food = {};

  food.board = board;
  food.tile = board.getEmptyTile();
  $(food.tile).addClass('food');

  food.eat = function () {
    this.tile.removeClass('food');
    this.tile = board.getEmptyTile();
    this.tile.addClass('food');
  };

  return food;
}

function makeSnake(game) {
  "use strict";
  var snake = { },
    startPosition = Math.floor(game.size / 2);

  snake.alive = true;
  snake.game = game;
  snake.headCoords = [startPosition, startPosition];
  snake.body = [game.board.getTile(snake.headCoords)]; // assumption: there will not be a wall there.

  snake.die = function() {
    this.alive = false;
    this.body[this.body.length - 1].addClass('tombstone');
    this.body[this.body.length - 1].removeClass('snake');
    highScore = Math.max(highScore, this.game.score); // TODO belongs elsewhere
  };
  snake.advance = function(newCoords, newTile) {
    this.grow(newCoords, newTile);
    var tail = this.body.shift();
    $(tail).removeClass('snake');
  };
  snake.grow = function(newCoords, newTile) {
    this.headCoords = newCoords;
    newTile.addClass('snake');
    this.body.push(newTile);
  };
  snake.move = function() {
    var unit = game.unit;
    var newCoords = normalize(addCoords(this.headCoords, unit)); // lint: addCoords, normalize out of scope
    var newTile = $(this.game.board.getTile(newCoords));
    var tileClass = $(newTile).attr('class').split(' ')[1]; // ignore 'tile' class (which comes first) and assume there's at most one other class
    switch (tileClass) {
      case 'food':
        game.food.eat(); // LoD fail!
        this.grow(newCoords, newTile);
        break;
      case 'wall':
      case 'snake': // fallthrough
        this.die(); 
        break;
      default:
        this.advance(newCoords, newTile);
        break;
    }
  };
  return snake;
}

// Non-jQuery stuff

function mod(n, divisor) {
  "use strict";
  var remainder = n % divisor;
  return(remainder < 0 ? remainder + divisor : remainder);
}

// eww
function normalize(coords) {
  "use strict";
  var newX = mod(coords[0], game.size); // lint: game out of scope
  var newY = mod(coords[1], game.size);
  return [newX, newY];
}

//TODO follow actual borders
function makeWallSet(size) {
  "use strict";
  // later may want to allow different wall sets
  return [[1, 1], [2, 2], [3, 3]];
}

function addCoords(startPosition, vector) {
  "use strict";
  var result = startPosition.map(function (val, index) {
    return val + vector[index];
  });
  return result;
}

function flatten(arr) {
  var flattened = [] // unnecessary intermediate arrays, oh well
  var i;
  for (i = 0; i < arr.length; i += 1) {
    flattened = flattened.concat(arr[i]);
  }
  return flattened;
}

// Gameplay
var game = {}; // global, eww
var highScore = 0;

$(document).ready(function () {
  "use strict";
  var boardElt = $('#board');
  boardElt.removeClass('js-off');
  $('#new-game').on('click', function() {
    boardElt.empty();
    setUpGame(game, boardElt);
    requestAnimationFrame(gameLoop); // lint: gameLoop out of scope, requestAnimationFrame undeclared
  });
  $(document).keypress(function(e) {
    setDirection(e.key); // lint: out of scope
  });
});

function updateScoreDisplay() {
  $('#high-score').text(highScore);
  $('#current-score').text(game.score);
}

function gameLoop() {
  "use strict";
  if (game.tick % 8 === 0) {
    game.snake.move();
    game.score = game.snake.body.length - 1;
    updateScoreDisplay();
  }
  if (game.snake.alive) {
    game.tick += 1;
    requestAnimationFrame(gameLoop);
  }
}

function setDirection(key) {
  "use strict";
  switch (key) {
  case 'ArrowLeft':
  case 'h': // (fallthrough)
    game.unit = [-1, 0];
    break;
  case 'ArrowUp':
  case 'k':
    game.unit = [0, -1];
    break;
  case 'ArrowRight':
  case 'l':
    game.unit = [1, 0];
    break;
  case 'ArrowDown':
  case 'j':
    game.unit = [0, 1];
    break;
  }
}
