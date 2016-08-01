require 'rails_helper'

describe AttachmentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:alt_question) { create(:question, user: create(:user)) }
  let!(:attachment) { create(:question_attachment, attachable: question) }
  let(:alt_attachment) { create(:question_attachment, attachable: alt_question) }

  let(:destroy_attachment) { delete :destroy, id: attachment, format: :js }
  let(:destroy_alt_attachment) { delete :destroy, id: alt_attachment, format: :js }

  describe 'DELETE #destroy' do
    before { sign_in user }

    context 'own question\'s attachment' do
      it 'deletes attachment' do
        expect { destroy_attachment }.to change(Attachment, :count).by(-1)
      end
    end

    context 'other user question\'s attachment' do
      before { alt_attachment }

      it 'doesn\'t delete attachment' do
        expect { destroy_alt_attachment }.to change(Attachment, :count).by(0)
      end

      it 'keeps attachment in DB' do
        destroy_alt_attachment
        expect(Attachment.exists?(alt_attachment.id)).to be true
      end
    end

    it 'renders to #destroy view' do
      destroy_attachment
      expect(response).to render_template :destroy
    end
  end
end
