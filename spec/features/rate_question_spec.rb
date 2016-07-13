require 'features_helper'

feature 'Rate the Question', %q(
  To select the best Question
  As a User
  I want to rate other Users' Questions and revoke my votes
) do
  describe 'Authenticated User' do
    scenario 'Can see Question Rating'
    scenario 'Can rate other User\'s Question'
    scenario 'Cannot see links to rate other User\'s Question second time'
    scenario 'Cannot see links to rate own Question'
    scenario 'Can revoke own vote and rate other Question'
  end
  scenario 'Unauthenticated user cannot see links to rate the Question'
end