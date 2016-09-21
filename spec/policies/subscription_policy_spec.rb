require 'rails_helper'

describe SubscriptionPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:any_question) { create(:question) }

  permissions :create?, :destroy? do
    it('allow user') { is_expected.to permit(user, any_question) }
    it('allow admin') { is_expected.to permit(create(:user, admin: true), any_question) }
    it('deny guest') { is_expected.not_to permit(nil, any_question) }
  end
end
