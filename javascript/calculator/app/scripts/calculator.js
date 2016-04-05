/*jslint browser: true, white: true, es6: true, for: true*/
/*global $*/
// for template strings to be allowed, need es6 version, which lacks indent and plusplus options

function make_keypad(calculator) {
  "use strict";
  var keys = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "*", "0", "CLR", "=", "/"],
    i,
    sym,
    key;
  for (i = 0; i < keys.length; i+=1) {
    sym = keys[i];
    key = $(`<div class="key" id="${sym}" tabindex="0"><span>${sym}</span></div>`);
    calculator.append(key);
  }
}

function update_display(display, val) {
  "use strict";
  var formatted = format(val);
  display.text(formatted);
}

function listen(display, history, key) {
  "use strict";
  process_input(history, key); // mutates history
  update_display(display, history);
}

$(document).ready(function () {
  "use strict";
  var calculator = $('#calculator'),
    history = [],
    display = $('#display');
  make_keypad(calculator);
  $(document).keypress(function (e) {
    if(e.keyCode === 13) { // enter
      $(':focus').click();
    }
  });
  $('.key').on('click', function () {
    listen(display, history, this.id); // I'm not sure what `this` does.
  });
});

