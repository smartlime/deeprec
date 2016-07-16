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

  def rating(user)
    ratings.sum(:rate, user: user)
  end
end