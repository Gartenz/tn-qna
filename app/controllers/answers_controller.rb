class AnswersController < ApplicationController
  before_action :authenticate_user!

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
end
