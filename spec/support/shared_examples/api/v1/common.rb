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

shared_examples :conform_common_json_api_format do |json_path = nil, has_relationships = true|
  context 'conform Common JSON API format' do
    it { is_expected.to have_json_size(1) }
    it { is_expected.to have_json_path('data') }

    # TODO: add 'attributes'
    (%w(id type) + (has_relationships ? [] : %w(relationships))).each do |attr|
      it { is_expected.to have_json_path([json_path, "data/0/#{attr}"].compact * '/') }
    end
  end
end

shared_examples :has_json_attributes do |object, methods, json_path = nil|
  methods.each do |attr|
    it { is_expected.to be_json_eql(object.send(attr.to_sym).to_json).
        at_merged_path("data/0/attributes/#{attr}", json_path) }
  end
end

def at_merged_path(json_path, json_merge_path = nil)
  at_path([json_merge_path, fix_underscores(json_path)].compact * '/')
end

def fix_underscores(string)
  string.gsub('_', '-')
end

## -- Just for debugging

shared_examples :show_body do
  it('...is for debug') { ap JSON.parse(body) }
end

def _sb
  include_examples :show_body
end
