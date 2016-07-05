require 'features_helper'

feature 'Attach files to Answer', %q(
  To provide extra data
  As an Answer author
  I want to attach files to the Answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User attaches a file when creates an Answer', :js do
    file_name = 'README.md'
    fill_in 'Your answer:', with: Faker::Lorem.paragraph(4, true, 8)
    attach_file 'File', "#{Rails.root}/#{file_name}"
    click_on 'Send an Answer'

    within '#answers' do
      expect(page).to have_link file_name,
                                href: "/uploads/attachment/file/1/#{file_name}"
    end
  end
end