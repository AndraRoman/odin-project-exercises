/*jslint browser: true, white: true, es6: true, this: true*/
/*global $, window*/

function createNavDot(slide, index) {
  'use strict';
  var anchor = $(`<a name="${index}"></a>`),
    dot = $(`<a href="#${index}"><div class="dot"></div></a>`);
  slide.prepend(anchor);
  return dot;
}

// int, int, int -> int
function moveInCircle(collectionSize, index, delta) {
  'use strict';
  return (index + delta) % (collectionSize);
}

function transition(oldSlide, newSlide) {
  'use strict';
  [newSlide, oldSlide].forEach(function(elt) {
    elt.fadeToggle('slow').toggleClass('selected');
  });
}

function updateDots(dots, currentIndex, newIndex) {
  'use strict';
  [currentIndex, newIndex].forEach(function(index) {
    dots.eq(index).toggleClass('current');
  });
}

function update(slides, dots, currentSlideIndex, newSlideIndex, timeout) {
  'use strict';
  transition(slides.eq(currentSlideIndex), slides.eq(newSlideIndex), timeout);
  timeout.restart();
  updateDots(dots, currentSlideIndex, newSlideIndex);
}

$(document).ready(function() {
  'use strict';
  $('#no-js').hide();
  var slides = $('.slide'),
    nav = $('#slide-nav'),
    slideCount = slides.length,
    currentSlideIndex = 0,
    newSlideIndex,
    dots,
    hash = window.location.hash,
    timeout = { 
      delay: 5000,
      action: function() {
        newSlideIndex = moveInCircle(slideCount, currentSlideIndex, 1);
        update(slides, dots, currentSlideIndex, newSlideIndex, this);
        currentSlideIndex = newSlideIndex;
      },
      restart: function() {
        window.clearTimeout(this.timeoutID);
        this.timeoutID = window.setTimeout(() => this.action(), this.delay); // arrow function lexically binds this; otherwise setTimeout would set it to the global object
      }
    },
    delta;

  slides.each(function(index) {
    nav.append(createNavDot($(this), index));
  });
  dots = $('.dot');
  dots.first().addClass('current');
  if (hash) {
    newSlideIndex = parseInt(hash.slice(1));
    update(slides, dots, currentSlideIndex, newSlideIndex, timeout);
    currentSlideIndex = newSlideIndex;
  };
  timeout.restart();

  $('.arrow-container').on('click', function() {
    delta = $(this).attr('id') === 'right' ? 1 : -1;
    newSlideIndex = moveInCircle(slideCount, currentSlideIndex, delta);
    update(slides, dots, currentSlideIndex, newSlideIndex, timeout);
    currentSlideIndex = newSlideIndex;
  });

  $('nav a').on('click', function() {
    newSlideIndex = parseInt($(this).attr("href").slice(1));
    update(slides, dots, currentSlideIndex, newSlideIndex, timeout);
    currentSlideIndex = newSlideIndex;
  });
});
