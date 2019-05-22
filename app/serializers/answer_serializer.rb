class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  belongs_to :user
  has_many :links
  has_many :files, serializer: FilesSerializer
  has_many :comments
end
