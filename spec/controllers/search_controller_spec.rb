require 'rails_helper'

describe SearchController do
  describe 'GET #search' do
    include_examples :search_with_sphinx, :question, :topic
    include_examples :search_with_sphinx, :question
    include_examples :search_with_sphinx, :answer
    include_examples :search_with_sphinx, :comment
    include_examples :search_with_sphinx, :user, :email
  end
end
