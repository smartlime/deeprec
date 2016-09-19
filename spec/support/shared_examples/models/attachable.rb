shared_examples_for :attachable do
  it { is_expected.to have_many(:attachments).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for :attachments }
end
