function toggle_activity(element) {
  if (element.hasClass('active')) {
    element.removeClass('active');
    element.addClass('inactive');
  } else {
    element.removeClass('inactive');
    element.addClass('active');
  }
}

$(document).ready(function() {
  "use strict";
  $('.tab:not(#menu)').addClass('inactive');
  $('[id|=menu]').addClass('active');
  $('[id$=link]').on('click', function() {
    var referent_id = $(this).attr('href').substr(1); // remove initial '#'
    [$('.active'), $(`[id|=${referent_id}]`)].map(toggle_activity);
  });
});
