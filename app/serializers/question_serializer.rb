class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  belongs_to :user
  has_many :links
  has_many :files, serializer: FilesSerializer
  has_many :comments
end
