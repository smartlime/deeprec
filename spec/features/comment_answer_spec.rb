require 'features_helper'
require 'support/shared_examples/comment_commentable'

feature 'User can left a comment to any answer', %q(
  To clarify the answer
  As an authenticated user
  I want to left a comment to the answer
) do

  include_examples :comment_commentable do
    let(:user) { create(:user) }
    let(:commentable) { create(:answer, user: user) }
  end
end
