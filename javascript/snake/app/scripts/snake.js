function makeSquare(x, y) {
  var tile = $(`<div class="tile" id="${x}-${y}"></div>`);
  return tile;
}

function makeRow(size, n) {
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
  var i, row;
  for (i = 0; i < size; i++) {
    row = makeRow(size, i);
    elt.append(row);
  }
  addWalls(elt, walls);
}

function findTile(coords) {
  var x = coords[0], y = coords[1];
  var tile = $(`.tile#${x}-${y}`);
  return tile;
}

function addWalls(board, wallSet) {
  var coords, i;
  for (i = 0; i < wallSet.length; i++) {
    coords = wallSet[i];
    findTile(coords).addClass('wall');
  }
}


function drawClass(className, rawCoords) {
  var coords = normalize(rawCoords);
  findTile(coords).addClass(className);
}

function gameLoop() {
  if(game.tick % 6 == 0) {
    update(game.direction, game.snake);
  }
  game.tick += 1;
  requestAnimationFrame(gameLoop);
}

function lose(board) {
  board.text('YOU LOST');
}

function setDirection(key) {
  switch(key) {
    case 37: // left
    case 104: // h (fallthrough)
      game.direction = [-1, 0];
      break;
    case 38: // up
    case 107: // k (fallthrough)
      game.direction = [0, -1];
      break;
    case 39: // right
    case 108: // l (fallthrough)
      game.direction = [1, 0];
      break;
    case 40: // down
    case 106: // j (fallthrough)
      game.direction = [0, 1];
      break;
  }
}

game = {
    direction: [0, 0],
    board: $('#board'),
    size: 20,
    snake: [[10, 10]], // snake is a queue
    food: [4, 4],
    walls: makeWallSet(this.size),
    tick: 0
  };

$(document).ready(function () {
  "use strict";
  game.board.removeClass('js-off');
  makeBoard(game.board, game.size, game.walls);
  requestAnimationFrame(gameLoop);
  $(document).keypress(function(e) {
    setDirection(e.keyCode);
  });
});

// Non-jQuery stuff

function mod(n, divisor) {
  var remainder = n % divisor;
  return(remainder < 0 ? remainder + divisor : remainder);
}

// eww
function normalize(coords) {
  var newX = mod(coords[0], game.size);
  var newY = mod(coords[1], game.size);
  return [newX, newY];
} 

//TODO follow actual borders
function makeWallSet(size) {
  // later may want to allow different wall sets
  return [[1, 1], [2, 2], [3, 3,]];
}

// TODO handle walls and food
// WHY IS THIS SLOW
function update(direction, snake) {
  var x = snake[snake.length-1][0] + direction[0];
  var y = snake[snake.length-1][1] + direction[1];
  var coords = [x, y];
  snake.push(coords);
  drawClass('snake', coords);//oops there goes purity
}
