App.cable.subscriptions.create('AnswersChannel', {
  connected() {
    console.log('Answers for question subscribed');
    if (gon.question_id)
      this.perform('follow', { id: gon.question_id })
  },
  received(data) {
    answer = $.parseJSON(data)
    console.log(answer)
    if (answer.user_id != gon.current_user_id) {
      new_answer = JST['templates/_answer'](answer)
      $('.answers-table').append(new_answer)
    }
  }
})
