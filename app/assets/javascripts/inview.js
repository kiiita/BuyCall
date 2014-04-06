$(function() {
  $('.home-img').on('inview', function() {
      $('.home-background').animate({
        "opacity": "1",
        "left": "-250px"
      }, 3000);
  });
});

