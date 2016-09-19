shared_examples :rated do
  before { sign_in user }

  describe 'POST #rate_inc' do
    it 'assigns @rateable to rateable instance' do
      post_rate_inc
      expect(assigns(:rateable)).to eq others_rateable
    end

    it 'changes rating for other users\' raleables' do
      expect { post_rate_inc }
          .to change { others_rateable.rating }.by(1)
    end

    it 'doesn\'t change rate for own rateables' do
      expect { post_rate_inc }.not_to change { rateable.rating }
    end

    it 'responses with HTTP status 200' do
      post_rate_inc
      expect(response.status).to eq 200
    end
  end

  describe 'POST #rate_dec' do
    it 'assigns @rateable to rateable instance' do
      post_rate_dec
      expect(assigns(:rateable)).to eq others_rateable
    end

    it 'changes rating for other users\' rateables' do
      expect { post_rate_dec }
          .to change { others_rateable.rating }.by(-1)
    end

    it 'doesn\'t change rate for own rateables' do
      expect { post_rate_dec }.not_to change { rateable.rating }
    end

    it 'responses with HTTP status 200' do
      post_rate_dec
      expect(response.status).to eq 200
    end
  end

  describe 'POST #rate_revoke' do
    before do
      own_rating
      others_rating
    end

    it 'assigns @rateable to rateadle instance' do
      post_rate_revoke
      expect(assigns(:rateable)).to eq rateable
    end

    it 'doesn\'t revoke rating for other users\' rateables' do
      expect { post_rate_revoke }
          .not_to change { others_rateable.rating }
    end

    it 'revokes rate for own rateables' do
      expect { post_rate_revoke }
          .to change { rateable.rating }.by(-1)
    end

    it 'responses with HTTP status 200' do
      post_rate_revoke
      expect(response.status).to eq 200
    end
  end
end
