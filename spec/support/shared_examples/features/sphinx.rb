shared_examples :sphinx_search_feature do |attribute = :body|
  given!(:junk_questions) { create_list(:question, 2) }
  given!(:junk_answers) { create_list(:answer, 2) }
  given!(:junk_comments) { create_list(:comment, 2) }
  given!(:junk_users) { create_list(:user, 2) }

  let!(:text) { object.send(attribute) }

  before { visit new_question_path }

  scenario "search with type in query" do
    within '#global-search' do
      fill_in 'q', with: text
      select object.class.name.downcase, from: 't'
      click_button 'Go!'
    end

    expect(current_path).to eq '/search'

    expect(page).to have_content text
    (junk_questions.map(&:topic) +
        junk_answers.map(&:body) +
        junk_comments.map(&:body) +
        junk_users.map(&:email)).each do |junk|
      expect(page).to_not have_content junk
    end
  end

  scenario 'search without type in query' do
    within '#global-search' do
      fill_in 'q', with: text
      click_button 'Go!'
    end

    expect(current_path).to eq '/search'
    expect(page).to have_content text
  end

  scenario 'search unsearchable' do
    within '#global-search' do
      fill_in 'q', with: 'unsearchablestring'
      click_button 'Go!'
    end

    expect(current_path).to eq '/search'
    expect(page).to_not have_content text
  end
end

