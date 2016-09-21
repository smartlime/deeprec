require 'rails_helper'

describe MailAnswerJob do
  DatabaseCleaner.clean!
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, user: user, question: question) }
  let(:answer) { create(:answer, question:question) }
  let(:message) { double(CustomMailer.delay) }

  it 'should send new Answer notifications' do
    expect(CustomMailer).to receive(:answer).with(user, answer).and_return(message)
    expect(message).to receive(:deliver_later)
    MailAnswerJob.perform_now(answer)
  end

  it_behaves_like(:delayed_job) { let(:args) { answer } }
end
