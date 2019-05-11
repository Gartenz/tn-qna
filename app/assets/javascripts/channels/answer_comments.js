$(document).on('turbolinks:load', function() {
  if(gon.question_answers_ids) {
    for(i = 0; i < gon.question_answers_ids.length; i++) {
      subscribeAnswerComments(gon.question_answers_ids[i])
    }
  }
});

function subscribeAnswerComments(id){
  App.cable.subscriptions.create({ channel: 'CommentsChannel', type: 'answer', id: id }, {
    received(data) {
      comment = $.parseJSON(data)
      console.log(comment)
      if (gon.current_user_id != comment.user_id) {
        new_comment = JST['templates/comment']({comment: comment})
        console.log(new_comment)
        console.log('answer-' + comment.commentable_id + '-comments')
        $('#answer-' + comment.commentable_id + '-comments').append(new_comment)
      }
    }
  });
}
