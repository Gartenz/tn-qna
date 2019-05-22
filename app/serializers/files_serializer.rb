class FilesSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url

  def filename
    object.filename.to_s
  end

  def url
    Rails.application.routes.url_helpers.url_for(object)
  end
end
