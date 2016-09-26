shared_examples_for :rateable do
  let (:user) { create(:user) }

  it { is_expected.to have_many(:ratings).dependent(:destroy) }

  describe '#rate_up! and #rating' do
    it 'stores rate' do
      expect { rateable.rate_up!(user) }
          .to change(rateable.ratings, :count).by(1)
    end

    it 'increases rate' do
      expect { rateable.rate_up!(user) }
          .to change { rateable.rating }.by(1)
    end
  end

  describe '#rate_down! and #rating' do
    it 'stores rate' do
      expect { rateable.rate_down!(user) }
          .to change(rateable.ratings, :count).by(1)
    end

    it 'decreases rate' do
      expect { rateable.rate_down!(user) }
          .to change { rateable.rating }.by(-1)
    end
  end

  describe '#revoke_rate! and #rating' do
    it 'revorkes rate' do
      rateable.rate_up!(user)
      expect { rateable.revoke_rate!(user) }
          .to change { rateable.rating }.to(0)
    end
  end

  describe '#rated? and #rate_up!' do
    it 'has the rateable not rated initially' do
      expect(rateable.rated?(rateable, user)).to eq false
    end

    it 'marks rateable as rated after #change_rate' do
      expect { rateable.rate_up!(user) }
          .to change { rateable.rated?(rateable, user) }.to(true)
    end
  end
end
