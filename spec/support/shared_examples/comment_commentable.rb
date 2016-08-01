shared_examples :comment_commentable do
  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can access new comment button'
    scenario 'can create a valid comment', :js
    scenario 'cannot create an invalid comment', :js
  end

  scenario 'Unauthenticated user cannot left comment'
end