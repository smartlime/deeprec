require 'rails_helper'

describe Question do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to have_many(:ratings).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for :attachments }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :topic }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_length_of(:topic).is_at_least(10) }
  it { is_expected.to validate_length_of(:topic).is_at_most(200) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }
  it { is_expected.to validate_length_of(:body).is_at_most(50_000) }

  it { is_expected.to have_db_index :user_id }

  describe 'acts as Rateable' do
    include_examples :rateable do
      let (:user) { create(:user) }
      let (:rateable) { create(:question, user: user) }
    end
  end
end
