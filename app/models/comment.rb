class Comment < ActiveRecord::Base
  belongs_to :user

  validates :body, presence: true, length: (2..2_000)
end
