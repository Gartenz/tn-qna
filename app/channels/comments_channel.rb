class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:type]}_comments"
  end
end
