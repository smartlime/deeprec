require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let!(:json_path) { nil }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #me' do
    let(:path) { me_api_v1_profiles_path }

    include_examples :unauthenticated, :get

    context 'when authenticated' do
      let(:object) { me }
      subject { response.body }

      before { get path, format: :json, access_token: access_token.token }

      it_behaves_like 'returns correct user(s) data'
    end
  end

  describe 'GET #all' do
    let(:path) { all_api_v1_profiles_path }

    include_examples :unauthenticated, :get

    context 'when authenticated' do
      let!(:other_user) { create(:user) }
      let(:object) { [other_user] }
      subject { response.body }

      before { get path, format: :json, access_token: access_token.token }

      it_behaves_like 'returns correct user(s) data'

      it { is_expected.not_to include_json(me.to_json) }
      it { is_expected.to have_json_size(1) }
    end
  end
end
