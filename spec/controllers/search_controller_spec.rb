require 'rails_helper'

describe SearchController do
  describe 'GET #search' do
    context 'when query is valid' do

      it 'should set @found'

      context 'performs search using Sphinx'

      subject { response }
      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :search }
    end

    context 'when query is invalid' do

      it 'shouldn\'t set @found'

      it 'shouldn\'t performs search using Sphinx'

      subject { response }
      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :search }
    end

  end
end
