shared_examples_for :comet_publisher do
  render_views

  it 'should publish valid request using PrivatePub' do
    expect(PrivatePub).to receive(:publish_to).with(pub_channel, /#{Regexp.quote(valid_response_entry)}/)
    valid_request
  end

  it 'shouldn\'t publish invalid request using PrivatePub' do
    expect(PrivatePub).to_not receive(:publish_to)
    invalid_request
  end
end
