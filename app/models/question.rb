class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, presence: true
  validates :topic, presence: true, length: (10..200)
  validates :body, presence: true, length: (20..50_000)
end
