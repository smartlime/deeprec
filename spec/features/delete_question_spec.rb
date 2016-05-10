require 'rails_helper'

feature 'User can delete own question', %(
  To delete unneeded question which I made
  As an anthenticated user
  I want to delete a question
) do
  scenario "Authorized user can delete own question"
  scenario "Authorized user cannot delete question of other user"
  scenario "Unauthorized user cannot delete questions"
end