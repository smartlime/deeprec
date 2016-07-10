require 'features_helper'

feature 'User can delete own Question\'s attachments', %q(
  To delete unneeded Attachment to the Question I made
  As an authenticated User
  I want to delete an Attachment to the Auestion
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:question_attachment, attachable: question) }

  describe 'Authenticated User' do
    scenario 'can delete own Attachment to the Question', :js do
      sign_in user
      visit question_path(question)

      within '#question-attachments' do
        expect(page).to have_link attachment.file.filename
        find("#delete-attachment-#{attachment.id}").click
        expect(page).to_not have_link attachment.file.filename
      end
    end

    scenario 'cannot see delete link for other User\'s Attachment to the Question' do
      @alt_user = create(:user)
      sign_in @alt_user
      visit question_path(question)

      within '#question-attachments' do
        expect(page).to have_link attachment.file.filename
        expect(page).to_not have_link "#delete-attachment-#{attachment.id}"
      end
    end
  end

  scenario 'Unauthenticated User cannot see delete attachment link' do
    visit question_path(question)

    within '#question-attachments' do
      expect(page).to have_link attachment.file.filename
      expect(page).to_not have_link "#delete-attachment-#{attachment.id}"
    end
  end
end