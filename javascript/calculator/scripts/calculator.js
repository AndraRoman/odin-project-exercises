$(document).ready(function() {
  var calculator = $('#calculator');
  var history = [];
  var display = $('#display');
  make_keypad(calculator);
  $(document).keypress(function(e) {
    if(e.keyCode == 13) { // enter
      $(':focus').click();
    }
  });
  $('.key').on('click', function() {listen(display, history, this.id)}); // I'm not sure what `this` does. Or why I need to declare a function here instead of just using one.
});

function make_keypad(calculator) {
  var special = ["=", "CLR"];
  var keys = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "*", "0", "CLR", "=", "/"];
  for (var i = 0; i < keys.length; i++) {
    var sym = keys[i];
    var key = $(`<div class="key" id="${sym}" tabindex="0"><span>${sym}</span></div>`);
    calculator.append(key);
  }
}

function listen(display, history, key) {
  process_input(history, key); // mutates history
  update_display(display, history);
}

function update_display(display, val) {
  formatted = format(val);
  display.text(formatted);
}
