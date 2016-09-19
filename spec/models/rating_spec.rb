require 'rails_helper'

describe Rating do
  it { is_expected.to belong_to :rateable }

  it { is_expected.to validate_presence_of :rateable_id }
  it { is_expected.to validate_presence_of :rateable_type }

  it { is_expected.to validate_inclusion_of(:rate).in_array([1, -1]) }

  it { is_expected.to have_db_index [:rateable_id, :rateable_type] }
  it { is_expected.to have_db_index [:user_id, :rateable_id, :rateable_type] }

  it_behaves_like :user_related
end
