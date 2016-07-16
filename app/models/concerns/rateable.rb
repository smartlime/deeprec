module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def change_rate!(delta)
    delta = delta <=> 0
    ratings.find_or_initialize_by(user: user).update!(rate: delta) if delta != 0
  end

  def revoke_rate!
    ratings.find_by(user: user).destroy!
  end

  def rating
    ratings.sum(:rate, user: user)
  end
end