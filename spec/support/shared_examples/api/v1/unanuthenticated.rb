shared_examples :unauthenticated do |method|
  context 'when not authenticated' do
    context 'status when no access_token' do
      subject { send method, path, format: :json }
      it { is_expected { response.status }.to be 401 }
    end

    context 'status when access_token is invalid' do
      subject { send method, path, format: :json, access_token: '00000' }
      it { is_expected { response.status }.to be 401 }
    end
  end
end
