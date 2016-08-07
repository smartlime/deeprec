shared_examples :comment_commentable do
  describe 'Authenticated User' do
    before do
      sign_in user
      visit_commentable_path
    end

    scenario 'can access new comment link' do
      within "##{commentable.entity}-comments-#{commentable.id}" do
        expect(page).to have_link 'Add a comment'
      end
    end

    scenario 'can create a valid comment', :js do
      comment = create(:comment)
      within "##{commentable.entity}-comments-#{commentable.id}" do
        click_on 'Add a comment'

        fill_in "#{commentable.entity}-#{commentable.id}-comment-body",
            with: comment.body
        click_on 'Add comment'

        expect(page).to have_content comment.body
      end
    end

    scenario 'cannot create an invalid comment', :js
  end

  scenario 'Unauthenticated user cannot left comment' do
    visit_commentable_path
    expect(page).not_to have_link 'Add a comment'
  end
end