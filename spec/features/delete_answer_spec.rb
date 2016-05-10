require 'rails_helper'

feature 'User can delete own answer', %(
  To delete unneeded answer which I made
  As an anthenticated user
  I want to delete an answer
) do
  scenario 'Authorized user can delete own question'
  scenario 'Authorized user cannot delete question of other user'
  scenario 'Unauthorized user don\'t see delete question button'
end
