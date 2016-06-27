require 'features_helper'

feature 'User can star the best answer to his question', %(
  To be able to choose best answer
  As an anthenticated user
  I want to start any answer to my own question
) do
  scenario 'Authenticated user can star any answer to his own question'
  scenario 'Authenticated user can star any other answer to his own question if there starred answer is already exists'
  scenario 'Authenticated user cannot star an answer to other user\'s question'
  scenario 'Starred answer is always first in answers list'
  scenario 'Unauthenticated user cannot star any answer to any question'
end
