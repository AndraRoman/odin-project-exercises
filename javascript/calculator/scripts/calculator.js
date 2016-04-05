$(document).ready(function() {
  var calculator = $('#calculator');
  var history = [];
  var display = $('#display');
  make_keypad(calculator);
  $('.key').on('click', function() {listen(display, history, this.id)}); // I'm not sure what `this` does. Or why I need to declare a function here instead of just using one.
});

function make_keypad(calculator) {
  var special = ["=", "CLR"];
  var keys = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "*", "0", "CLR", "=", "/"];
  for (var i = 0; i < keys.length; i++) {
    var sym = keys[i];
    var key = $(`<div class="key" id="${sym}"><span>${sym}</span></div>`);
    calculator.append(key);
    console.log(keys[i]);
  }
}

function listen(display, history, key) {
  if(key == "CLR") {
    history.length = 0;
  } else if(key == "=") {
    result = evaluate(history);
    history.length = 0;
    history.push(result);
  } else {
    history.push(key);
  }
  update_display(display, history);
}

function update_display(display, val) {
  formatted = format(val);
  display.text(formatted);
}
