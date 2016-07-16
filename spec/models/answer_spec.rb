require 'rails_helper'

RSpec.describe Answer do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }

  it { should validate_length_of(:body).is_at_least(20) }
  it { should validate_length_of(:body).is_at_most(50_000) }

  it { should have_db_index :user_id }
  it { should have_db_index :question_id }

  describe('#star!') do
    it 'should star the selected answer' do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question, starred: true)
      answer3 = create(:answer, question: question)
      question.save!
      answer3.star!
      expect(question.reload.answers).to eq([answer1, answer2, answer3])
      expect(answer1.reload.starred).to eq(false)
      expect(answer2.reload.starred).to eq(false)
      expect(answer3.reload.starred).to eq(true)
    end
  end

  let (:user) { create(:user) }
  let (:answer) { create(:answer, user: user) }

  describe '#change_rate! and #rating' do
    it 'should store rate with 1' do
      expect { answer.change_rate!(1, user) }.to change(answer.ratings, :count).by(1)
    end

    it 'should increase rate with 1' do
      expect { answer.change_rate!(1, user) }.to change { answer.rating }.by(1)
    end

    it 'should store rate with -1' do
      expect { answer.change_rate!(-1, user) }.to change(answer.ratings, :count).by(1)
    end

    it 'should decrease rate with -1' do
      expect { answer.change_rate!(-1, user) }.to change { answer.rating }.by(-1)
    end
  end

  describe '#revoke_rate! and #rating' do
    it 'should revorke rate' do
      answer.change_rate!(1, user)
      expect { answer.revoke_rate!(user) }.to change { answer.rating }.to(0)
    end
  end

  describe '#rated? and #change_rate!' do
    it 'should have the answer not rated initially' do
      expect(answer.rated?(answer, user)).to eq false
    end

    it 'should mark answer as rated after #change_rate' do
      expect { answer.change_rate!(1, user) }
          .to change { answer.rated?(answer, user) }.to(true)
    end
  end
end
