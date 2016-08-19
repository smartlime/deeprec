require 'features_helper'
require 'support/shared_examples/comments'

feature 'User can left a comment to any question', %q(
  To clarify the question
  As an authenticated user
  I want to left a comment to the question
) do

  include_examples :comments do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:commentable) { question }
  end
end
