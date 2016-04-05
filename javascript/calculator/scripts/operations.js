// Basic operations

function add(m, n) {
  var result = m + n;
  return result;
}

function multiply(m, n) {
  var result = m * n;
  return result;
}

function subtract(m, n) {
  var result = m - n;
  return result;
}

function divide(m, n) {
  var result = m / n;
  return result;
}

// Parsing

// TODO
// array of strings -> array of some integers and some strings (operator symbols)
function parse(arr) {
}

// TODO actually implement this instead of cheating
// takes array of numbers and operator symbols. numbers have already been grouped.
function evaluate(arr) {
  return eval(format(arr));
}

// String processing
function format(arr) {
  return arr.join("");
}
