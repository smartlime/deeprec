class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :topic, presence: true, length: (10..200)
  validates :body, presence: true, length: (20..50_000)
end
