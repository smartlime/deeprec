shared_examples :sphinx_search_controller do |entity, attribute = :body|
  context 'with type in query' do
    include_examples :sphinx_search_controller_with_params, entity, attribute, entity.to_s.first
  end

  context 'without type in query' do
    include_examples :sphinx_search_controller_with_params, entity, attribute, ''
  end
end

shared_examples :sphinx_search_controller_with_params do |entity, attribute, search_type, validity = true|
  if entity == :empty
    let!(:object) { '' }
    attribute = :to_s
  else
    let!(:object) { create(entity) }
  end

  context "search by #{entity.to_s.capitalize}.#{attribute}" do
    if validity
      it 'calls SearchService' do
        expect(SearchService).to receive(:klass).with(search_type).
            and_return(search_type.empty? ? ThinkingSphinx : object.class)
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
  end

  context 'execute search on empty database' do
    before { get :search, q: object.send(attribute), t: search_type }
    subject { response }

    it "sets @found to #{validity ? 'empty Array' : 'nil'}" do
      get :search, q: object.send(attribute), t: search_type
      expect(assigns(:found)).to eq validity ? [] : nil
    end

    it { is_expected.to have_http_status validity ? :success : :not_implemented }

    it("renders #{validity ? ':no_results' : 'nothing'}") do
      is_expected.to render_template validity ? :no_results : nil
    end
  end
end
