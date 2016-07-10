require 'rails_helper'

describe AttachmentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:question_attachment, attachable: question) }

  describe 'DELETE #destroy' do
    before { sign_in user }

    context 'own question\'s sttachment' do
      it 'deletes attachment' do
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
      end
    end

    context 'other user question\'s attachment' do
      before do
        @alt_question = create(:question, user: create(:user))
        @alt_attachment = create(:question_attachment, attachable: @alt_question)
      end

      it 'doesn\'t delete attachment' do
        expect { delete :destroy, id: @alt_attachment, format: :js }.to change(Attachment, :count).by(0)
      end

      it 'keeps attachment in DB' do
        delete :destroy, id: @alt_attachment, format: :js
        expect(Attachment.exists?(@alt_attachment.id)).to be true
      end

    end

    it 'renders to #destroy view' do
      delete :destroy, id: attachment, format: :js
      expect(response).to render_template :destroy
    end

  end

end
