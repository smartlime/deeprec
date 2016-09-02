require 'rails_helper'

describe AccountController do
  let (:user) { create(:user) }

  describe 'GET #confirm_email' do
    context 'as unauthenticated user' do
      context 'with valid OAuth data in session'
      context 'with invalid OAuth data in session'
      context 'with no OAuth data in session'
    end
    context 'as authenticated user'
  end

  describe 'PATCH #confirm_email' do
    context 'as unauthenticated user' do
      context 'with valid OAuth data in session'
      context 'with invalid OAuth data in session'
      context 'with no OAuth data in session'
    end
    context 'as authenticated user'
  end
end
