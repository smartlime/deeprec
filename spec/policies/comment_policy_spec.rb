require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:any_comment) { create(:comment) }
  let(:users_comment) { create(:comment, user: user) }

  permissions :show? do
    it('allow guest') { is_expected.to permit(nil, any_comment) }
  end

  permissions :show?, :create? do
    it('allow user') { is_expected.to permit(user, any_comment) }
    it('allow admin') { is_expected.to permit(create(:user, admin: true), any_comment) }
  end

  permissions :create? do
    it('deny guest') { is_expected.not_to permit(nil, any_comment) }
  end
end
