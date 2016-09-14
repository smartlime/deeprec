require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /me' do
    include_examples :unauthorized, 'profiles/me'

    context 'when authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      subject { response }
      it { is_expected.to be_success }

      context 'for authorized user' do
        subject { response.body }

        %w(id email created_at updated_at admin).each do |attr|
          it { is_expected.to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
        end

        %w(password encrypted_password).each do |attr|
          it { is_expected.to_not have_json_path(attr) }
        end
      end
    end
  end

  describe 'GET /all' do
    include_examples :unauthorized, 'profiles/all'

    context 'when authorized' do
      let!(:other_user) { create(:user) }

      before { get '/api/v1/profiles/all', format: :json, access_token: access_token.token }

      subject { response }
      it { is_expected.to be_success }

      context 'for authorized user' do
        subject { response.body }

        it { is_expected.not_to include_json(me.to_json) }
        it { is_expected.to have_json_size(1) }

        %w(id email created_at updated_at admin).each do |attr|
          it { is_expected.to be_json_eql(other_user.send(attr.to_sym).to_json).at_path("0/#{attr}") }
        end

        %w(password encrypted_password).each do |attr|
          it { is_expected.to_not have_json_path("0/#{attr}") }
        end
      end
    end
  end
end
