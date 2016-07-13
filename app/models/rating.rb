class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :user_id, :rateable_id, :rateable_type, presence: true
  validates :user_id, uniqueness: { scope: [:rateable_id, :rateable_type] }
  validates :rate, inclusion: { in: [1, -1] }

end
