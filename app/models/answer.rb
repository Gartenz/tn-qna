class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, :question, presence: true

  after_create :send_email_notification

  private

  def send_email_notification
    SubscribersNotifyJob.perform_now(self)
  end

end
