require 'rails_helper'
require 'support/shared_examples/rated'

describe Answer do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :question }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to have_many(:ratings).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for :attachments }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :question_id }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_length_of(:body).is_at_least(20) }
  it { is_expected.to validate_length_of(:body).is_at_most(50_000) }

  it { is_expected.to have_db_index :user_id }
  it { is_expected.to have_db_index :question_id }

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

  describe 'acts as Rateable' do
    include_examples :rateable do
      let (:user) { create(:user) }
      let (:rateable) { create(:answer, user: user) }
    end
  end
end
