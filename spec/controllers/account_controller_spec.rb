require 'rails_helper'

describe AccountController do
  let!(:user) { create(:user) }

  describe 'GET #confirm_email' do
    subject { get :confirm_email }

    context 'as unauthenticated user' do
      context 'with valid OAuth data in session' do
        before do
          session['devise.oauth_provider'] = generate(:provider)
          session['devise.oauth_uid'] = generate(:uid)
        end

        it { is_expected.to have_http_status :success }
        it { is_expected.to render_template :confirm_email }
      end

      context 'with invalid OAuth data in session' do
        before do
          session['devise.oauth_provider'] = generate(:provider)
          session['devise.uid'] = nil
        end

        it { is_expected.to have_http_status :redirect }
        it { is_expected.to redirect_to new_user_session_path }
      end

      context 'with no OAuth data in session' do
        it { is_expected.to have_http_status :redirect }
        it { is_expected.to redirect_to questions_path }
      end
    end

    context 'as authenticated user' do
      sign_in_user

      before { get :confirm_email }

      it { is_expected.to have_http_status :redirect }
      it { is_expected.to redirect_to questions_path }
    end
  end

  describe 'PATCH #confirm_email' do
    let(:email) { generate(:email) }
    subject (:confirm_email) { patch :confirm_email, user: {email: email} }

    context 'as unauthenticated user' do
      context 'with valid OAuth data in session' do
        before do
          session['devise.oauth_provider'] = generate(:provider)
          session['devise.oauth_uid'] = generate(:uid)
        end

        context 'with correct email' do
          it { is_expected.to have_http_status :redirect }

          it 'should assign User object to @user' do
            confirm_email
            expect(assigns(:user)).to be_a User
          end

          context 'for new user' do
            it 'should create new User instance' do
              expect { confirm_email }.to change(User, :count).by(1)
            end

            it 'should create new Identity for the User' do
              expect { confirm_email }.to change(Identity, :count).by(1)
            end

            it 'should set given email for new User' do
              confirm_email
              expect(assigns(:user).email).to eq email
            end
          end

          context 'for existing user' do
            subject(:confirm_email) { patch :confirm_email, email: user.email }

            it 'shouldn\'t create new User instance' do
              expect { confirm_email }.not_to change(User, :count)
            end

            it 'shouldn\'t create new Identitities' do
              expect { confirm_email }.not_to change(Identity, :count)
            end
          end
        end

        context 'with invalid (empty) email' do
          subject(:confirm_email) { patch :confirm_email }

          it { is_expected.to have_http_status :success }
          it { is_expected.to render_template :confirm_email }

          it 'shouldn\'t create new Identitities' do
            expect { confirm_email }.not_to change(Identity, :count)
          end
        end
      end

      context 'with invalid OAuth data in session' do
        before do
          session['devise.oauth_provider'] = generate(:provider)
          session['devise.uid'] = nil
        end

        it { is_expected.to have_http_status :redirect }
        it { is_expected.to redirect_to new_user_session_path }
      end

      context 'with no OAuth data in session' do
        it { is_expected.to have_http_status :redirect }
        it { is_expected.to redirect_to questions_path }
      end
    end

    context 'as authenticated user' do
      sign_in_user

      before { get :confirm_email }

      it { is_expected.to have_http_status :redirect }
      it { is_expected.to redirect_to questions_path }
    end
  end
end
