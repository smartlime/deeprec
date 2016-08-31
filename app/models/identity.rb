class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, presence: true
  validates :uid, presence: true, uniqueness: {scope: :provider}
end
