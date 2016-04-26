class Question < ActiveRecord::Base
  validates :topic, presence: true, length: (10..50)
  validates :body, presence: true, length: (20..8192)
  validates :rating, numericality: {only_integer: true}
  validates :rating, numericality: {equal_to: 0, on: :create}
end
