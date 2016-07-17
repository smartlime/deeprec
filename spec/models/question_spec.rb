require 'rails_helper'

RSpec.describe Question do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :topic }
  it { should validate_presence_of :body }

  it { should validate_length_of(:topic).is_at_least(10) }
  it { should validate_length_of(:topic).is_at_most(200) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should validate_length_of(:body).is_at_most(50_000) }

  it { should have_db_index :user_id }

  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }
  describe '#rate_up! and #rating' do
    it 'should store rate' do
      expect { question.rate_up!(user) }.to change(question.ratings, :count).by(1)
    end

    it 'should increase rate' do
      expect { question.rate_up!(user) }.to change { question.rating }.by(1)
    end
  end

  describe '#rate_down! and #rating' do
    it 'should store rate' do
      expect { question.rate_down!(user) }.to change(question.ratings, :count).by(1)
    end

    it 'should decrease rate' do
      expect { question.rate_down!(user) }.to change { question.rating }.by(-1)
    end
  end

  describe '#revoke_rate! and #rating' do
    it 'should revorke rate' do
      question.rate_up!(user)
      expect { question.revoke_rate!(user) }.to change { question.rating }.to(0)
    end
  end

  describe '#rated? and #rate_up!' do
    it 'should have the question not rated initially' do
      expect(question.rated?(question, user)).to eq false
    end

    it 'should mark question as rated after #change_rate' do
      expect { question.rate_up!(user) }
          .to change { question.rated?(question, user) }.to(true)
    end
  end
end
