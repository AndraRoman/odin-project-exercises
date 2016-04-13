$(document).ready(function() {
  "use strict";
  $('#no-js').hide();
  var current = $('.selected'),
    next = current.next().hide(); // have to explicitly hide before fadeIn can work
  [current, next].map(function (elt) {
    elt.fadeToggle(700);
  });
});
