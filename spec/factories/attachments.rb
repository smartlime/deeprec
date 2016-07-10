FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'README.md')) }
    association :attachable, factory: :question
  end

  factory :answer_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'README.md')) }
    association :attachable, factory: :answer
  end
end
