class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }
  expose :answer, -> { question.answers.new }

  def new
    question.links.new
  end

  def show
    answer.links.new
  end

  def update
    question.update(question_params)
  end

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question deleted successfully.'
    else
      render :show, alert: 'You can not delete not your own question'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

end
