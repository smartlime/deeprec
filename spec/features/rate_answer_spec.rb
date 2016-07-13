require 'features_helper'

feature 'Rate the Answer', %q(
  To select the best Answer
  As a User
  I want to rate other Users' Answers and revoke my votes
) do
  describe 'Authenticated User' do
    scenario 'Can see Answer Rating'
    scenario 'Can rate other User\'s Answer'
    scenario 'Cannot see links to rate other User\'s Answer second time'
    scenario 'Cannot see links to rate own Answer'
    scenario 'Can revoke own vote and rate other Answer'
  end
  scenario 'Unauthenticated user cannot see links to rate the Answer'
end