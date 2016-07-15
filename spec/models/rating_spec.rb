require 'rails_helper'

describe Rating do
  it { should belong_to :user }
  it { should belong_to :rateable }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :rateable_id }
  it { should validate_presence_of :rateable_type }

  it { should validate_inclusion_of(:rate).in_array([1, -1]) }

  it { should have_db_index [:rateable_id, :rateable_type] }
  it { should have_db_index [:user_id, :rateable_id, :rateable_type] }
end
