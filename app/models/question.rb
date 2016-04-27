class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :topic, presence: true, length: (10..200)
  validates :body, presence: true, length: (20..50000)
  validates :rating, numericality: { only_integer: true }
  validates :rating, numericality: { equal_to: 0, on: :create }
end
