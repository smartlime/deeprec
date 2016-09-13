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

shared_examples :has_valid_json_object_at do # |json_path, *fields|
  ap object
  context 'va' do
    size = object.try(:size)
    name = (size ? object.first : object).class.name.downcase
    it("should have #{name.capitalize} element") { is_expected.to have_json_path(name) }

    fields.each do |attr|
      it { is_expected.to be_json_eql(question.send(attr.to_sym).to_json).
          at_path("#{name}/#{attr}") }
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
