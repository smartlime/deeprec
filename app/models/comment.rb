class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user_id, presence: true
  validates :body, presence: true, length: (2..2_000)
end
