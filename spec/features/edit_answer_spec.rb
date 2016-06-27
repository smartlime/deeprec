require 'features_helper'

feature 'User can edit own answer to any question', %(
  To be able to correct mistake in answer or provide an extra information
  As an anthenticated user
  I want to edit my own answer to any question
) do
  scenario 'Authenticated user can access edit button for his own answer to any question'
  scenario 'Authenticated user can edit his own answer to any question'
  scenario 'Authenticated user cannot edit his own answer to any question with incorrect data'
  scenario 'Authenticated user cannot access edit button for other user\'s answer to any question'
  scenario 'Authenticated user cannot edit other user\'s answer to any question'
  scenario 'Authenticated user cannot edit his own answer to any question with incorrect data'
  scenario 'Unauthenticated user cannot edit any answer to any question'
end
