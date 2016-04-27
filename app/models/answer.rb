class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true, length: (20..8192)
  validates :rating, numericality: { only_integer: true }
  validates :rating, numericality: { equal_to: 0, on: :create }
end
