require "rails_helper"

RSpec.describe CustomMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2, user: user, created_at: Time.now.yesterday) }
    let(:question_ids) { questions.map(&:id) }
    let(:date) { Date.yesterday.strftime('%d.%m.%Y') }
    let(:mail) { CustomMailer.digest(user, question_ids) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n::t('custom_mailer.digest.subject', date: date))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["e@varnakov.ru"])
    end

    context 'renders the body' do
      subject { mail.body.encoded }

      it('should match title') { is_expected.to match('Deep Recursion') }
      it('should match letter type') { is_expected.to match('Digest') }
      it('should match date') { is_expected.to match(date) }

      it 'should match questions topics and URLs' do
        questions.each do |question|
          is_expected.to match(question.topic)
          is_expected.to match(url_for(question))
        end
      end
    end
  end

  # describe 'answer' do
  #   let(:mail) { CustomMailer.answer }
  #
  #   it 'renders the headers' do
  #     expect(mail.subject).to eq("Answer")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end
  #
  #   it 'renders the body' do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end
end
