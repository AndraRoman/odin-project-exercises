function toggle_activity(element) {
  if (element.hasClass('active')) {
    element.removeClass('active');
    element.addClass('inactive');
  } else {
    element.removeClass('inactive');
    element.addClass('active');
  }
}

function switch_to_tab(name) {
  name = name.substr(1); // remove initial '#'
  [$('.active'), $(`[id|=${name}]`)].map(toggle_activity);
}

$(document).ready(function() {
  "use strict";
  $('.tab:not(#menu)').addClass('inactive');
  $('[id|=menu]').addClass('active');

  var hash = window.location.hash;
  if (hash) {
    switch_to_tab(hash);
  }  

  $('[id$=link]').on('click', function() {
    var name = $(this).attr('href')
    switch_to_tab(name);
  });
});
