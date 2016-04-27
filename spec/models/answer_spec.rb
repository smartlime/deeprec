require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { pending; should validate_presence_of :body }

  it { pending; should validate_length_of(:body).is_at_least(20) }
  it { pending; should validate_length_of(:body).is_at_most(8192) }

  it { pending; should validate_numericality_of(:rating).only_integer }
  it { pending; should validate_numericality_of(:rating).is_equal_to(0).on(:create) }

  it { should have_db_index :question_id }
  it { should have_db_index :rating }
end
