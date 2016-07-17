module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def rate_up!(user)
    change_rate!(1, user)
  end

  def rate_down!(user)
    change_rate!(-1, user)
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

  private

  def change_rate!(delta, user)
    ratings.find_or_initialize_by(user: user).update!(rate: delta) if delta != 0
  end
end