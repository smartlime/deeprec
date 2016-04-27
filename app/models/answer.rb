class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true, length: (20..200)
end
