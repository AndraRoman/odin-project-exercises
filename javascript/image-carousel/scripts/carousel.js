function transition(oldSlide, newSlide) {
  'use strict';
  [newSlide, oldSlide].map(function(elt) {
    elt.fadeToggle('slow').toggleClass('selected');
  });
}

$(document).ready(function() {
  'use strict';
  $('#no-js').hide();
  var slides = $('.slide');

  $('.arrow-container').on('click', function() {
    var current = $('.selected'),
      position = current.index(),
      target = ($(this).attr('id') == 'left') ? prevSlide(slides, position): nextSlide(slides, position);
    transition(current, target);
  });
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
