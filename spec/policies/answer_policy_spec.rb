require 'rails_helper'

RSpec.describe AnswerPolicy do

  let(:user) { User.new }

  subject { described_class }

  # permissions '.scope'
  # permissions :show?
  # permissions :create?

  permissions :update? do
    it 'grant to admin' do
      is_expected.to permit(User.new(admin: true), create(:answer))
    end

    it 'grant to Answer\'s author' do
      is_expected.to permit(user, user.answers.build)
    end

    it 'deny for not Answer\'s author' do
      is_expected.not_to permit(User.new, user.answers.build)
    end

    it 'deny for guest' do
      is_expected.not_to permit(nil, user.answers.build)
    end
  end

  # permissions :destroy?
end
