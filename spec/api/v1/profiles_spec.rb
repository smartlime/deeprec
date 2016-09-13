require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'when not authorized' do
      context 'status when no access_token' do
        subject { get '/api/v1/profiles/me', format: :json }
        it { is_expected { response.status }.to be 401 }
      end

      context 'status when access_token is invalid' do
        subject { get '/api/v1/profiles/me', format: :json, access_token: '00000' }
        it { is_expected { response.status }.to be 401 }
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

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
end