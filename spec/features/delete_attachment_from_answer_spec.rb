require 'features_helper'

feature 'User can delete own Answer\'s attachments', %q(
  To delete unneeded Attachment to the Answer I made
  As an authenticated User
  I want to delete an Attachment to the Answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:answer_attachment, attachable: answer) }

  describe 'Authenticated User' do
    scenario 'can delete own Attachment to the Answer', :js do
      sign_in user
      visit question_path(question)

      within '#answers' do
        expect(page).to have_link attachment.file.filename
        find("#delete-attachment-#{attachment.id}").click
        expect(page).to_not have_link attachment.file.filename
      end
    end

    scenario 'cannot see delete link for other User\'s Attachment to the Answer' do
      @alt_user = create(:user)
      sign_in @alt_user
      visit question_path(question)

      within '#answers' do
        expect(page).to have_link attachment.file.filename
        expect(page).to_not have_link "#delete-attachment-#{attachment.id}"
      end
    end
  end

  scenario 'Unauthenticated User cannot see delete attachment link' do
    visit question_path(question)

    within '#answers' do
      expect(page).to have_link attachment.file.filename
      expect(page).to_not have_link "#delete-attachment-#{attachment.id}"
    end
  end
end
