shared_examples :search_with_sphinx do |entity, attribute = :body|
  context "searching on #{entity.to_s.capitalize}.#{attribute}" do
    context 'with valid search type' do
      include_examples :search_with_sphinx_with_search_type, entity, attribute, entity.to_s.first
    end

    context 'without search type' do
      include_examples :search_with_sphinx_with_search_type, entity, attribute, ''
    end

    context 'with invalid search type' do
      include_examples :search_with_sphinx_with_search_type, entity, attribute, 'INVALID', false
    end
  end
end

shared_examples :search_with_sphinx_with_search_type do |entity, attribute, search_type, validity = true|
  let!(:object) { create(entity) }

  if validity
    it 'calls SearchService' do
      expect(SearchService).to receive(:klass).with(search_type).and_return(object.class)
      expect(SearchService).to receive(:search).
          with(type: search_type, query: object.send(attribute)).and_call_original
      get :search, q: object.send(attribute), t: search_type
    end
  else
    it 'doesn\'t call SearchService' do
      expect(SearchService).to_not receive(:klass)
      expect(SearchService).to_not receive(:search)
      get :search, q: object.send(attribute), t: search_type
    end
  end

  context 'executing search on empty database' do
    before { get :search, q: object.send(attribute), t: search_type }
    subject { response }

    it "sets @found to #{validity ? 'empty Array' : 'nil'}" do
      get :search, q: object.send(attribute), t: search_type
      expect(assigns(:found)).to eq validity ? [] : nil
    end

    it { is_expected.to have_http_status validity ? :success : :not_implemented }
    it { is_expected.to render_template validity ? :no_results : nil }
  end
end
