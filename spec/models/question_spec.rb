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

  let (:question) { create(:question) }
  describe '#change_rate!' do
    it 'should store rate with 1' do
      expect { question.change_rate!(1) }.to change(question.ratings, :count).by(1)
    end

    it 'should increase rate with 1' do
      expect { question.change_rate!(1) }.to change { question.rating }.by(1)
    end

    it 'should store rate with -1' do
      expect { question.change_rate!(-1) }.to change(question.ratings, :count).by(1)
    end

    it 'should decrease rate with -1' do
      expect { question.change_rate!(-1) }.to change { question.rating }.by(-1)
    end
  end

  describe '#revoke_rate!' do
    it 'revorkes rate' do
      question.change_rate!(1)
      expect { question.revoke_rate!}.to change { question.rating }.to(0)
    end
  end
end
