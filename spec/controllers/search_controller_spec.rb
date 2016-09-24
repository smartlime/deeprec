require 'rails_helper'

describe SearchController do
  describe 'GET #search' do
    include_examples :sphinx_search_controller, :question, :topic
    include_examples :sphinx_search_controller, :question
    include_examples :sphinx_search_controller, :answer
    include_examples :sphinx_search_controller, :comment
    include_examples :sphinx_search_controller, :user, :email

    context 'search with invalid search type' do
      include_examples :sphinx_search_controller_with_params, :empty, :empty, 'INVALID', false
    end
  end
end
