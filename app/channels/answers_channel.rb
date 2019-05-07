class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "question_#{params['id']}"
  end
end
