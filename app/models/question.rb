class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def mark_best(answer)
    if answers.include?(answer)
      old_best = best_answer
      return if old_best&.id == answer.id
      
      transaction do
        old_best&.update!(best: false)
        answer.update!(best: true)
      end
    end
  end
end
