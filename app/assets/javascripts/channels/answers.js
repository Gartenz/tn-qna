App.cable.subscriptions.create('AnswersChannel', {
  connected() {
    if (gon.question_id)
      this.perform('follow', { id: gon.question_id })
  },
  received(data) {
    answer = $.parseJSON(data)
    if (answer.user_id != gon.current_user_id) {
      new_answer = JST['templates/_answer']({answer: answer})
      $('.answers-table').append(new_answer)
      subscribeAnswerComments(answer.id)
    }
  }
})
