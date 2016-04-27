/*jslint indent: 2 plusplus: true*/
"use strict";

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

function toOperator(op_symbol) {
  var operators = {"+": add, "*": multiply, "-": subtract, "/": divide},
    op = operators[op_symbol];
  return op;
}

// Things I shouldn't have to write
Array.prototype.last = function () {
  return this[this.length - 1];
};

// Parsing

// TODO get rid of this
// true for undefined argument
function is_operator(sym) {
  return isNaN(sym);
}

// TODO generalize
function higher_precedence(op_1, op_2) {
  return ((op_1 === "*" || op_1 === "/") && (op_2 === "+" || op_2 === "-"));
}

// TODO handle parens
// Shunting-yard algorithm
function to_rpn(tokens) {
  var op_stack = [],
    output_queue = [],
    tok,
    i,
    prev_op;
  for (i = 0; i < tokens.length; i++) {
    tok = tokens[i];
    if (is_operator(tok)) {
      prev_op = op_stack.last();
      if (prev_op && !higher_precedence(tok, prev_op)) {
        output_queue.push(prev_op);
        op_stack.pop();
      }
      op_stack.push(tok);
    } else {
      output_queue.push(tok);
    }
  }
  while (op_stack.length > 0) {
    output_queue.push(op_stack.pop());
  }
  return output_queue;
}

function eval_rpn(queue) {
  var stack = [],
    i,
    token,
    first_arg,
    second_arg,
    partial_result;
  for (i = 0; i < queue.length; i++) {
    token = queue[i];
    if (is_operator(token)) {
      second_arg = stack.pop();
      first_arg = stack.pop();
      partial_result = toOperator(token)(first_arg, second_arg);
      stack.push(partial_result);
    } else {
      stack.push(token);
    }
  }
  return stack.pop();
}

function evaluate(tokens) {
  var rpn_queue = to_rpn(tokens),
    result = eval_rpn(rpn_queue);
  return result;
}

// String processing
function format(arr) {
  return arr.join("");
}

function add_digit(num, ch) {
  var digit = +ch,
    sign = Math.sign(num),
    result = num * 10 + sign * digit;
  return result;
}

// Main
function process_input(history, key) {
  var last_key = history.last(),
    result,
    new_num;
  if (key === "CLR") {
    history.length = 0;
  } else if (key === "=") {
    result = evaluate(history);
    history.length = 0;
    history.push(result);
  } else if (is_operator(key) && !is_operator(last_key)) {
    history.push(key); // ignore multiple operators in a row
  } else if (!is_operator(key) && is_operator(last_key)) {
    history.push(+key);
  } else if (!(is_operator(key))) {
    new_num = add_digit(last_key, key);
    history[history.length - 1] = new_num;
  }
}

// there has to be a better way to do this
if (typeof (module) !== 'undefined' && typeof (module.exports) !== 'undefined') {
  module.exports = {
    add: add,
    multiply: multiply,
    subtract: subtract,
    divide: divide,
    toOperator: toOperator,
    is_operator: is_operator,
    higher_precedence: higher_precedence,
    to_rpn: to_rpn,
    eval_rpn: eval_rpn,
    evaluate: evaluate,
    format: format,
    add_digit: add_digit,
    process_input: process_input
  };
}
