class CommentsController < ApplicationController
  before_action :set_commented, only: %i[create]
  after_action :publish_comment, only: %i[create]

  expose :comment

  def create
    @exposed_comment = @commented.comments.new(comment_params)
    comment.user = current_user
    comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commented
    id = params["#{params['commentable'].downcase}_id"]
    @commented = params['commentable'].classify.constantize.find(id)
  end

  def publish_comment
    return if comment.errors.any?

    ActionCable.server.broadcast(
      "#{@commented.class.name.downcase}_comments",
      ApplicationController.render(
        partial: 'comments/comment_channel',
        locals: {comment: comment}
      )
    )
  end
end
