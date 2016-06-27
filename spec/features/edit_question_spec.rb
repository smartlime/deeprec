require 'features_helper'

feature 'Authenticated user can edit his own question', %(
  To be able to correct mistake in answer or provide an extra information
  As an anthenticated user
  I want to edit my question
) do
  describe 'Authenticated User' do
    scenario 'Authenticated user can access edit link for his own question'
    scenario 'Authenticated user can edit his own question with correct data'
    scenario 'Authenticated user cannot edit his own question with incorrect data'
    scenario 'Authenticated user cannot access edit link for other user\'s question'
  end
  scenario 'Unauthenticated user cannot edit any question'
end