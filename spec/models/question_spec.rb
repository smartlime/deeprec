require 'rails_helper'

RSpec.describe Question do
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :topic }
  it { should validate_presence_of :body }

  it { should validate_length_of(:topic).is_at_least(10) }
  it { should validate_length_of(:topic).is_at_most(200) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should validate_length_of(:body).is_at_most(50_000) }
end
