shared_examples :rateable do
  describe '#rate_up! and #rating' do
    it 'should store rate' do
      expect { rateable.rate_up!(user) }
          .to change(rateable.ratings, :count).by(1)
    end

    it 'should increase rate' do
      expect { rateable.rate_up!(user) }
          .to change { rateable.rating }.by(1)
    end
  end

  describe '#rate_down! and #rating' do
    it 'should store rate' do
      expect { rateable.rate_down!(user) }
          .to change(rateable.ratings, :count).by(1)
    end

    it 'should decrease rate' do
      expect { rateable.rate_down!(user) }
          .to change { rateable.rating }.by(-1)
    end
  end

  describe '#revoke_rate! and #rating' do
    it 'should revorke rate' do
      rateable.rate_up!(user)
      expect { rateable.revoke_rate!(user) }
          .to change { rateable.rating }.to(0)
    end
  end

  describe '#rated? and #rate_up!' do
    it 'should have the rateable not rated initially' do
      expect(rateable.rated?(rateable, user)).to eq false
    end

    it 'should mark rateable as rated after #change_rate' do
      expect { rateable.rate_up!(user) }
          .to change { rateable.rated?(rateable, user) }.to(true)
    end
  end
end