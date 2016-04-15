/*jslint browser: true, white: true, es6: true, this: true*/
/*global $, window*/

// [slide], int, int -> slide; direction will be +/- 1
function moveInCircle(collection, index, direction) {
  'use strict';
  var newIndex = (index + direction) % (collection.length);
  return collection.eq(newIndex); // to get jQuery object rather than plain DOM element
}
// index, [slide] -> slide
function nextSlide(elements, startIndex) {
  'use strict';
  return moveInCircle(elements, startIndex, 1);
}

// index, [slide] -> slide
function prevSlide(elements, startIndex) {
  'use strict';
  return moveInCircle(elements, startIndex, -1);
}

function transition(oldSlide, newSlide) {
  'use strict';
  [newSlide, oldSlide].forEach(function(elt) {
    elt.fadeToggle('slow').toggleClass('selected');
  });
}

function transitionTowards(slides, currentSlide, direction, timeout) {
  'use strict';
  var position = currentSlide.index(),
    target = (direction < 0 ? prevSlide(slides, position) : nextSlide(slides, position));
  timeout.restart(); // this is convenient but doesn't really belong here
  transition(currentSlide, target);
}

$(document).ready(function() {
  'use strict';
  $('#no-js').hide();
  var slides = $('.slide'),
    timeout = { 
      delay: 5000,
      action: function() {
        transitionTowards(slides, $('.selected'), 1, this);
      },
      restart: function() {
        window.clearTimeout(this.timeoutID);
        this.timeoutID = window.setTimeout(() => this.action(), this.delay); // arrow function lexically binds this; otherwise setTimeout would set it to the global object
      }
    };
  timeout.restart();

  $('.arrow-container').on('click', function() {
    var current = $('.selected'),
      direction = $(this).attr('id') === 'right' ? 1 : -1;
    transitionTowards(slides, current, direction, timeout);
  });
});

