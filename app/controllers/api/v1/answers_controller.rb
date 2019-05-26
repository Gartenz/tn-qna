class Api::V1::AnswersController < Api::V1::BaseController
  expose :question
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }

  def index
    answers = Question.find(params['question_id']).answers
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    answer = Answer.where(id:params['id']).first
    render json: answer
  end

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_resource_onwer
    if answer.save
      render json: answer, location: api_v1_answer_path(answer)
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def update
    if answer.update(answer_params)
      render json: answer, location: api_v1_answer_path(answer)
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def destroy
    answer.destroy
    head :ok
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
