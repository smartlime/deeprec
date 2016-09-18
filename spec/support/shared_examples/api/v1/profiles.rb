shared_examples 'returns correct user(s) data' do
  it { expect(response).to be_success }

  include_examples :has_valid_json_fields, %w(id email created_at updated_at admin)
  include_examples :has_no_json_fields, %w(password encrypted_password)
end
