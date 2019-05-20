class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check
  skip_authorize_resource

  expose(:attachment) { ActiveStorage::Attachment.find(params[:id]) }
  expose(:record) { attachment.record }

  def destroy
    if current_user.author_of?(record)
      attachment.purge
    end
  end
end
