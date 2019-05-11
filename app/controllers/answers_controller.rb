class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: %i[create]

  expose :question
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  def best
    if current_user.author_of?(answer.question)
      @exposed_question = answer.question
      question.mark_best(answer)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{answer.question.id}",
      ApplicationController.render(
        partial: 'answers/answer_channel',
        locals: {answer: answer}
      )
    )
  end
end
