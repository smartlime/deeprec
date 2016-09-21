class MailAnswerJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    # users = User.where('id=1')
    # ap users
    # users.find_each do |user|
    CustomMailer.answer(User.first, answer).deliver_later
  end
end
