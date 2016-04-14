function transition(oldSlide, newSlide) {
  'use strict';
  newSlide.hide(); // have to explicitly hide before fadeIn can work - 0 opacity and display: none aren't enough for jQuery to know the item can be faded in
  [oldSlide, newSlide].map(function(elt) {
    elt.fadeToggle('slow');
  });
}

$(document).ready(function() {
  'use strict';
  $('#no-js').hide();
  var slides = $('.slide'),
    current = $('.selected');
  transition(current, nextSlide(slides, 0));
});

// Non-jQuery stuff below

// [slide], int, int -> slide; direction will be +/- 1
function moveInCircle(collection, index, direction) {
  var newIndex = (index + direction) % (collection.length);
  return collection.eq(newIndex); // to get jQuery object rather than plain DOM element
}
// index, [slide] -> slide
function nextSlide(elements, startIndex) {
  return moveInCircle(elements, startIndex, 1);
}

// index, [slide] -> slide
function prevSlide(elements, startIndex) {
  return moveInCircle(elements, startIndex, -1);
}
