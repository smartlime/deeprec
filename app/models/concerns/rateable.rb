module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def change_rate!(delta, user)
    delta = delta <=> 0
    ratings.find_or_initialize_by(user: user).update!(rate: delta) if delta != 0
  end

  def revoke_rate!(user)
    ratings.find_by(user: user).destroy!
  end

  def rated?(rateable, user)
    ratings.exists?(rateable: rateable, user: user)
  end

  def rating
    ratings.sum(:rate)
  end
end