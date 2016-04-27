require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :topic }
  it { should validate_presence_of :body }

  it { should validate_length_of(:topic).is_at_least(10) }
  it { should validate_length_of(:topic).is_at_most(50) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should validate_length_of(:body).is_at_most(8192) }

  it { should validate_numericality_of(:rating).only_integer }
  it { should validate_numericality_of(:rating).is_equal_to(0).on(:create) }

  it { should have_db_index :rating }
end
