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

function findTile(board, coords) {
  var x = coords[0], y = coords[1];
  var tile = board.find(`#${x}-${y}`);
  return tile;
}

function addWalls(board, wallSet) {
  var coords, i;
  for (i = 0; i < wallSet.length; i++) {
    coords = wallSet[i];
    findTile(board, coords).addClass('wall');
  }
}

//TODO follow actual borders
function makeWallSet(size) {
  // later may want to allow different wall sets
  return [[1, 1], [2, 2], [3, 3,]];
}

// TODO handle walls and food
function update(direction, snake) {
  console.log("updating with " + direction);
  var x = snake[snake.length-1][0] + direction[0];
  var y = snake[snake.length-1][1] + direction[1];
  snake.push([x, y]);
}

function draw(game) {
  findTile(game.board, game.food).addClass('food');
  // TODO I don't like this
  for (var i = 0; i < game.snake.length; i++) {
    findTile(game.board, game.snake[i]).addClass('snake');
  }
}

function gameLoop() {
  game.clock = (game.clock + 1) % 30; // throttle refresh rate to keep snake moving at a reasonable pace
  if(game.clock % 30 == 0) {
    update(game.direction, game.snake);
    draw(game);
  }
  requestAnimationFrame(gameLoop);
}

function lose(board) {
  board.text('YOU LOST');
}

function setDirection(key) {
  switch(key) {
    case 37: // left
      game.direction = [-1, 0];
      break;
    case 38: // up
      game.direction = [0, -1];
      break;
    case 39: // right
      game.direction = [1, 0];
      break;
    case 40: // down
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
    clock: 0
  };

$(document).ready(function () {
  "use strict";
  game.board.removeClass('js-off');
  makeBoard(game.board, game.size, game.walls);
  draw(game);
  requestAnimationFrame(gameLoop);
  $(document).keypress(function(e) {
    setDirection(e.keyCode);
  });
});
