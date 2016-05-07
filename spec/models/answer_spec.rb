require 'rails_helper'

RSpec.describe Answer do
  it { should belong_to :question }

  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }

  it { should validate_length_of(:body).is_at_least(20) }
  it { should validate_length_of(:body).is_at_most(50_000) }

  it { should have_db_index :question_id }
end
