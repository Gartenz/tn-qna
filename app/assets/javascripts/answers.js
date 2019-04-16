$(document).on('turbolinks:load', function() {
  $('.answers').on('click','.edit-answer-link', function (e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('td#edit-answer-' + answerId).removeClass('hidden')
  })
})