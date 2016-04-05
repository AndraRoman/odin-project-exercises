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

function apply(op_symbol, m, n) {
  var operators = {"+": add, "*": multiply, "-": subtract, "/": divide};
  var op = operators[op_symbol];
  return op(m, n);
}

// Parsing

function is_operator(sym) {
  return isNaN(sym);
}

function higher_precedence(op_1, op_2) {
  return ((op_1 == "*" || op_1 == "/") && (op_2 == "+" || op_2 == "-"));
}

function lex(input) {
  var tokens = [];
  var token_in_progress = [];
  for (var i = 0; i < input.length; i++) {
    var sym = input[i];
    if(is_operator(sym)) {
      last_token = format(token_in_progress);
        tokens.push(+last_token); // unary + converts string to number
      token_in_progress = [];
      tokens.push(sym);
    } else {
      token_in_progress.push(sym);
    }
  }
  last_token = format(token_in_progress);
  if(last_token.length > 0) {
    tokens.push(+last_token); // repeated
  }
  return tokens;
}

// No particular reason for this to happen after lexing. May combine later.
// Shunting-yard algorithm
function to_rpn(tokens) {
  var op_stack = [];
  var output_queue = [];
  for(var i = 0; i < tokens.length; i++) {
    var tok = tokens[i];
    if(is_operator(tok)) {
      var prev_op = op_stack[op_stack.length - 1];
      if(prev_op && !higher_precedence(tok, prev_op)) {
        output_queue.push(prev_op);
        op_stack.pop();
      }
      op_stack.push(tok);
    } else {
      output_queue.push(tok);
    }
  }
  while(op_stack.length > 0) {
    output_queue.push(op_stack.pop());
  }
  return output_queue;
}

// Again I don't think this needs to be separate but it's easier to think about for now
function eval_rpn(queue) {
  stack = [];
  for(var i = 0; i < queue.length; i++) {
    var token = queue[i];
    if (is_operator(token)) {
      var second_arg = stack.pop();
      var first_arg = stack.pop();
      var partial_result = apply(token, first_arg, second_arg);
      stack.push(partial_result);
    } else {
      stack.push(token);
    }
  }
  return stack.pop();
}

function evaluate(arr) {
  tokens = lex(arr);
  rpn_queue = to_rpn(tokens);
  result = eval_rpn(rpn_queue);
  return result;
}

// String processing
function format(arr) {
  return arr.join("");
}

// Main
function process_input(history, key) {
  var last_key = history[history.length - 1];
  if(key == "CLR") {
    history.length = 0;
  } else if(key == "=") {
    result = evaluate(history);
    history.length = 0;
    history.push(result);
  } else if (!(is_operator(key) && is_operator(last_key))) {
    history.push(key); // ignore multiple operators in a row
  }
}
