shared_examples :has_valid_json_object_at do |json_path, fields = []|
  include_examples :set_json_object_size

  let(:name) { (size > 0 ? object.first.class.name.downcase.pluralize : object.class.name.downcase) }
  let(:full_json_path) { (json_path.blank? ? name : [json_path, name].compact * '/') + '/' }

  it { is_expected.to have_json_path(full_json_path) }

  it do
    if size > 0
      is_expected.to have_json_type(Array).at_path(full_json_path)
      is_expected.to have_json_size(size).at_path(full_json_path)
    else
      is_expected.to have_json_type(Hash).at_path(full_json_path)
    end
  end

  include_examples(:has_valid_json_fields, fields) { let!(:json_path) { full_json_path } }
end

shared_examples :has_valid_json_fields do |fields|
  include_examples :set_json_object_size

  fields.each do |attr|
    it { is_expected.to be_json_eql((size > 0 ? object.first : object).send(attr.to_sym).to_json).
        at_path("#{json_path}#{size > 0 ? '0/' : ''}#{attr}") }
  end
end

shared_examples :has_no_json_fields do |fields|
  include_examples :set_json_object_size

  fields.each do |attr|
    it { is_expected.to_not have_json_path("#{json_path}#{size > 0 ? '0/' : ''}#{attr}") }
  end
end

shared_examples :set_json_object_size do
  let(:size) { object.try(:size).to_i }
end