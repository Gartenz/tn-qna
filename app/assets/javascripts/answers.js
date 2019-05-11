$(document).on('turbolinks:load', function() {
  $('.answers').on('click','.edit-answer-link', function (e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('div#edit-answer-' + answerId).removeClass('hidden')
  });

  $('.answers').on('ajax:success', 'span', function(e) {
    var result = e.detail[0];
    $('.answer-score-'+result.answer.id).text(result.answer.score)
  });
});
