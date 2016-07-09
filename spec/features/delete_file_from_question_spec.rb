require 'features_helper'

feature 'User can delete own Question\'s attachments', %q(
  To delete unneeded Attachment to the Question I made
  As an authenticated User
  I want to delete an Attachment to the Auestion
) do
  given(:user) { create(:user) }

  describe 'Authenticated User' do
    before do
      sign_in user
      visit questions_path
    end

    scenario 'can delete own Attachment to the Question'
    scenario 'cannot delete other User\'s Attachment to the Question'
  end

  scenario 'Unauthenticated User cannot see delete attachment link'

end