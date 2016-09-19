require 'rails_helper'

describe Comment do
  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_length_of(:body).is_at_least(2) }
  it { is_expected.to validate_length_of(:body).is_at_most(2_000) }

  it_behaves_like :user_related
end
