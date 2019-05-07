App.cable.subscriptions.create('AnswersChannel', {
  connected() {
    console.log('Answers for question subscribed');
    if (gon.question_id)
      this.perform('follow', { id: gon.question_id })
  },
  received(data) {
    console.log(data)
    new_answer = JST['templates/answer'](data)
    $('.answers table tr:last').after(new_answer)
  }
})
