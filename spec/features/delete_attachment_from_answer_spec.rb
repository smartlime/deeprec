require 'features_helper'

feature 'User can delete own Answer\'s attachments', %q(
  To delete unneeded Attachment to the Answer I made
  As an authenticated User
  I want to delete an Attachment to the Answer
) do
  given(:user) { create(:user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can delete own Attachment to the Answer'
    scenario 'cannot delete other User\'s Attachment to the Answer'
  end

  scenario 'Unauthenticated User cannot see delete attachment link'

  end