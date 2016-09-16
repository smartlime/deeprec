shared_examples :unauthenticated do |ez_path|
  let(:uri) { "/api/v1/#{(path || ez_path).to_s}" }
  context 'when not authenticated' do
    context 'status when no access_token' do
      subject { get uri, format: :json }
      it { is_expected { response.status }.to be 401 }
    end

    context 'status when access_token is invalid' do
      subject { get uri, format: :json, access_token: '00000' }
      it { is_expected { response.status }.to be 401 }
    end
  end
end

shared_examples :has_valid_json_object_at do |json_path = nil, fields = []|
  let(:size) { object.try(:size).to_i }
  let(:name) { (size > 0 ? object.first.class.name.downcase.pluralize : object.class.name.downcase) }
  let(:path) { [json_path, name].compact * '/' }

  it { is_expected.to have_json_path(path) }

  it do
    if size > 0
      is_expected.to have_json_type(Array).at_path(path)
      is_expected.to have_json_size(size).at_path(path)
    else
      is_expected.to have_json_type(Hash).at_path(path)
    end
  end

  fields.each do |attr|
    it { is_expected.to be_json_eql((size > 0 ? object.first : object).send(attr.to_sym).to_json).
        at_path("#{path}#{size > 0 ? '/0' : ''}/#{attr}") }
  end
end

## -- Just for debugging
shared_examples(:show_body) { it('...is for debug') { ap JSON.parse(body) } }
def _sb; include_examples :show_body; end
