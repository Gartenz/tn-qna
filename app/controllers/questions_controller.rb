class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: %i[create]

  skip_authorization_check only: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }
  expose :answer, -> { question.answers.new }

  def new
    question.links.new
    question.build_reward
  end

  def show
    answer.links.new
    gon.question_id = question.id
    gon.question_user_id = question.user_id
    gon.question_answers_ids = question.answers.pluck(:id)
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
                                     files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: question }
      )
    )
  end
end
