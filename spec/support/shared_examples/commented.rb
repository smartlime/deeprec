shared_examples :commented do
  describe 'POST #create' do
    sign_in_user

    it 'assigns @commentable' do
      expect(assigns(:commentable)).to eq commentable
    end

    context 'with valid attributes' do
      it 'stores Comment in the database'
      it 'associates Comment with correct User'
    end

    context 'with invalid attributes' do
      it 'doesn\'t store Comment in the database'
    end

    it 'renders :create template'
  end
end