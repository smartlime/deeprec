require 'rails_helper'

RSpec.describe ProfilePolicy do
  let(:guest) { nil }
  let(:user) { create(:user) }

  subject { described_class }

  permissions :me?, :all? do
    it('deny guest') { is_expected.not_to permit(guest) }
    it('allow user') { is_expected.to permit(user) }
  end
end