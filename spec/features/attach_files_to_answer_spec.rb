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
    fill_in 'Your answer:', with: Faker::Lorem.paragraph(4, true, 8)
  end

  scenario 'User attaches a file when creates an Answer', :js do
    file_name = 'README.md'
    attach_file 'File', "#{Rails.root}/#{file_name}"
    click_on 'Send an Answer'

    within '#answers' do
      expect(page).to have_link file_name,
          href: "/uploads/attachment/file/1/#{file_name}"
    end
  end

  scenario 'User attaches more than own file when creates an Answer', :js do
    file_names = %w(README.md Gemfile .ruby-version)
    file_names.each do |file_name|
      within page.all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/#{file_name}"
      end
      click_on 'Add attachment'
    end
    click_on 'Send an Answer'

    within '#answers' do
      file_names.each_with_index do |file_name, cnt|
        expect(page).to have_link file_name,
            href: "/uploads/attachment/file/#{cnt + 1}/#{file_name}"
      end
    end
  end
end