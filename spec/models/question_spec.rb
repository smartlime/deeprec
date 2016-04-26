require 'rails_helper'

RSpec.describe Question, type: :model do
  pending it { should validate_presence_of :topic }
  pending it { should validate_presence_of :body }
  pending it { should validate_presence_of :rating }

  pending it { should validate_length_of(:topic).is_at_least(10) }
  pending it { should validate_length_of(:topic).is_at_most(50) }
  pending it { should validate_length_of(:body).is_at_least(20) }
  pending it { should validate_length_of(:body).is_at_most(8192) }

  it { should have_db_index :rating}
end
