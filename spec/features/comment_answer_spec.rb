require 'features_helper'
require 'support/shared_examples/comments'

feature 'User can left a comment to any answer', %q(
  To clarify the answer
  As an authenticated user
  I want to left a comment to the answer
) do

  include_examples :comments do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:commentable) { answer }
  end
end
