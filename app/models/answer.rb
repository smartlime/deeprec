class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, presence: true
  validates :body, presence: true, length: (20..50_000)

  def star!
    question.transaction do
      question.answers.where(starred: true).update_all(starred: false)
      update!(starred: true)
    end
  end
end
