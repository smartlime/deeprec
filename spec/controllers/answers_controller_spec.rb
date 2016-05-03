require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do

    context 'with valid attributes' do
      xit 'stores new answer in the database'
    end

    context 'with invalid attributes' do
      xit 'doesn\'t store the question'
    end

    xit 'redirects to show Questions view'
  end
end
