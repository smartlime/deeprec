require 'features_helper'
require 'support/shared_examples/comment_commentable'

feature 'User can left a comment to any question', %q(
  To clarify the question
  As an authenticated user
  I want to left a comment to the question
) do

  include_examples :comment_commentable do
    let(:user) { create(:user) }
    let(:commentable) { create(:question, user: user) }
  end
end
