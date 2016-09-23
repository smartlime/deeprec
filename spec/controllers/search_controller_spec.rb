require 'rails_helper'

shared_examples :search_some do |object|
  # let!(:object) { create(:question) }

  it 'should call SearchService with corrent params' do
    expect(SearchService).to receive(:klass).with('q').and_return(Question)
    expect(SearchService).to receive(:search).with(type: 'q', query: object.topic).and_call_original
    get :search, q: object.topic, t: 'q'
  end

  context 'calling search on empty database' do
    before { get :search, q: object.topic, t: 'q' }
    subject { response }

    it 'should set @found to empty Array' do
      get :search, q: object.topic, t: 'q'
      expect(assigns(:found)).to eq []
    end

    it { is_expected.to have_http_status :success }
    it { is_expected.to render_template :no_results }
  end
end

describe SearchController do
   describe 'GET #search' do

     include_examples :search_some, let!(:question) { create(:question) }

    #   let!(:object) { create(:question) }
    #
    #   # context 'when query is invalid' do
    #   #   subject { get :search, t: 'ZZZ' }
    #   #
    #   #   it 'shouldn\'t set @found'
    #   #
    #   #   it 'shouldn\'t performs search using Sphinx'
    #   #
    #   #   subject { response }
    #   #   it { is_expected.to have_http_status :success }
    #   #   it { is_expected.to render_template :no_results }
    #   # end
    #
    #   it 'should call SearchService with corrent params' do
    #     #question = double(:question, title: Faker::Lorem.sentence)
    #     expect(SearchService).to receive(:klass).with('q').and_return(Question)
    #     expect(SearchService).to receive(:search).with(type: 'q', query: object.topic).and_call_original
    #     get :search, q: object.topic, t: 'q'
    #   end
    #
    #   context 'calling search on empty database' do
    #     before { get :search, q: object.topic, t: 'q' }
    #     subject { response }
    #
    #     it 'should set @found to empty Array' do
    #       get :search, q: object.topic, t: 'q'
    #       expect(assigns(:found)).to eq []
    #     end
    #
    #     it { is_expected.to have_http_status :success }
    #     it { is_expected.to render_template :no_reqults }
    #   end
  end
end
