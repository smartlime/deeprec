require 'features_helper'

feature 'Search Questions, Answers, Comments and Users', %q(
  To get information I need
  As a Guest
  I want to search information in Questions, Answers, Comments and User emails
) do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment) }
  given!(:user) { create(:user) }

  background { visit questions_path }

  describe 'In global scope' do
    scenario 'search Questions' do
      within '#global-search' do
        fill_in 'q', with: question.topic
        click_button 'Go!'
      end

      expect(current_path).to eq '/search'

      expect(page).to have_content question.topic
      expect(page).not_to have_content answer.body
      expect(page).not_to have_content comment.body
      expect(page).not_to have_content user.email
    end
  end

  #   scenario 'search Answers' do
  #     fill_in 'q', with: answer.body
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  #
  #   scenario 'search Comments' do
  #     fill_in 'q', with: comment.body
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  #
  #   scenario 'search Users' do
  #     fill_in 'q', with: user.email
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).to have_content user.email
  #   end
  #
  #   scenario 'search unsearchable' do
  #     fill_in 'q', with: 'thetextthatfactorycannotgenerate'
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  # end
  #
  # describe 'In typed scope' do
  #   scenario 'search Questions' do
  #     fill_in 'q', with: question.topic
  #     select 'q', from: 'type'
  #     click_on 'Search'
  #     expect(page).to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  #
  #   scenario 'search Answers' do
  #     fill_in 'q', with: answer.body
  #     select 'a', from: 'type'
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  #
  #   scenario 'search Comments' do
  #     fill_in 'q', with: comment.body
  #     select 't', from: 'type'
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
  #
  #   scenario 'search Users' do
  #     fill_in 'q', with: user.email
  #     select 'u', from: 'type'
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).to have_content user.email
  #   end
  #
  #   scenario 'search with invalid type' do
  #     fill_in 'q', with: 'thetextthatfactorycannotgenerate'
  #     select 'x', from: 'type'
  #     click_on 'Search'
  #     expect(page).not_to have_content question.topic
  #     expect(page).not_to have_content answer.body
  #     expect(page).not_to have_content comment.body
  #     expect(page).not_to have_content user.email
  #   end
end
