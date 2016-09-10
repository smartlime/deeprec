require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:any_answer) { create(:answer) }
  let(:users_answer) { create(:answer, user: user) }

  # permissions '.scope'
  # permissions :show?
  # permissions :create?

  permissions :update?, :destroy? do
    it 'allow admin' do
      is_expected.to permit(User.new(admin: true), create(:answer))
    end

    it 'allow Answer\'s author' do
      is_expected.to permit(user, user.answers.build)
    end

    it 'deny not Answer\'s author' do
      is_expected.not_to permit(User.new, user.answers.build)
    end

    it 'deny guest' do
      is_expected.not_to permit(nil, user.answers.build)
    end
  end

  permissions :rate? do
    it('allow user') { is_expected.to permit(user, any_answer) }
    it('allow admin') { is_expected.to permit(admin, any_answer) }

    it('deny guest') { is_expected.not_to permit(nil, any_answer) }
    it('deny author') { is_expected.not_to permit(user, users_answer) }
  end

  permissions :rate_revoke? do
    it('allow author') { is_expected.to permit(user, users_answer) }
    it('allow admin') { is_expected.to permit(admin, any_answer) }

    it('deny guest') { is_expected.not_to permit(nil, any_answer) }
    it('deny user') { is_expected.not_to permit(user, any_answer) }
  end

end
