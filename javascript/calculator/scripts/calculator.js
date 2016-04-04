$(document).ready(function() {
  var calculator = $('#calculator');
  var current_val = 0;
  make_keypad(calculator);
  $('.key').on('click', function() {listen(this.id)}); // I'm not sure what `this` does. Or why I need to declare a function here instead of just using one.
});

function make_keypad(calculator) {
  var special = ["=", "CLR"];
  var keys = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "*", "0", "CLR", "=", "/"];
  for (var i = 0; i < keys.length; i++) {
    var sym = keys[i];
    var kind;
    if(!isNaN(sym)) {
      kind = "int";
    } else if(sym == "=" || sym == "CLR") { // empty string, true, and false will look numeric but that's ok here
      kind = "special";
    } else {
      kind = "operator";
    }
    var key = $(`<div class="key ${kind}" id="${sym}">${sym}</div>`);
    calculator.append(key);
    console.log(keys[i]);
  }
}

// TODO allow keyboard use too

function listen(val) { // TODO
  console.log("You just clicked " + val + "!");
}
