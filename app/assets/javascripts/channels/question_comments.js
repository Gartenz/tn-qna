App.cable.subscriptions.create({ channel: 'CommentsChannel', type: 'question', id: gon.question_id}, {
  received(data) {
    comment = $.parseJSON(data)
    if (gon.current_user_id != comment.user_id) {
      new_comment = JST['templates/comment']({comment: comment})
      $('.question-comments').append(new_comment)
    }
  }
})
