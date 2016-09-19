shared_examples :comments do
  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can access new comment link', :js do
      within "##{commentable.entity}-comments-#{commentable.id}-container" do
        expect(page).to have_link 'Add a comment'
      end
    end

    scenario 'can create a valid comment', :js do
      comment = create(:comment)
      within "##{commentable.entity}-comments-#{commentable.id}-container" do
        click_on 'Add a comment'

        expect(page).to have_button 'Add comment'
        fill_in "#{commentable.entity}-comments-#{commentable.id}-body",
            with: comment.body
        click_on 'Add comment'

        expect(page).to have_content comment.body
        expect(page).not_to have_button 'Add comment'
      end
    end

    scenario 'cannot create an invalid comment', :js do
      within "##{commentable.entity}-comments-#{commentable.id}-container" do
        click_on 'Add a comment'

        expect(page).to have_button 'Add comment'
        fill_in "#{commentable.entity}-comments-#{commentable.id}-body",
            with: nil
        click_on 'Add comment'

        expect(page).to have_button 'Add comment'
      end
    end
  end

  scenario 'Unauthenticated user cannot left comment' do
    visit question_path(question)
    expect(page).not_to have_link 'Add a comment'
  end
end