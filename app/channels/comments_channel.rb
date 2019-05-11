class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:type]}_#{params[:id]}_comments"
  end
end
