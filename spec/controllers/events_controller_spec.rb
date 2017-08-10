require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new event to database' do
        expect { post :create, params: { event: attributes_for(:event) }, format: :js }.to change(@user.events, :count).by(1)
      end

      it 'current user link to the new event' do
        post 'create', params: { event: attributes_for(:event), format: :js }
        expect(assigns("event").owner).to eq @user
      end

      it 'render template create' do
        post :create, params: { event: attributes_for(:event), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the event' do
        expect { post :create, params: { event: attributes_for(:invalid_event), format: :js }}.to_not change(Event, :count)
      end

      it 'render template create' do
        post :create, params: { event: attributes_for(:invalid_event), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:event) { @user.create_event(Date.today, "event 1") }

    context 'with valid attributes' do
      it 'assigns the requested event to @event' do
        patch :update, params: {id: event, event: {body: 'Body new'}, format: :js}
        expect(assigns(:event)).to eq event
      end

      it 'change event attributes' do
        patch :update, params: {id: event, event: {body: 'Body new'}, format: :js}
        event.reload
        expect(event.body).to eq 'Body new'
      end

      it 'render updated template' do
        patch :update, params: {id: event, event: {body: 'Body new'}, format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change event attributes' do
        body = event.body
        patch :update, params: {id: event,
                                event: attributes_for(:invalid_event).merge(owner_id: nil), format: :js}
        event.reload
        expect(event.body).to eq body
        expect(event.owner).to_not eq nil
      end

      it 'render updated template' do
        patch :update, params: {id: event,
                                event: attributes_for(:invalid_event).merge(owner_id: nil), format: :js}
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'owner delete event' do
      event = @user.create_event(Date.today, "new event")
      expect {delete :destroy, params: {id: event, format: :js}}.to change(Event, :count).by(-1)
    end

    it 'user can not delete event of other owner' do
      user1 = create(:user)
      event1 = user1.create_event(Date.today, "new body")
      expect {delete :destroy, params: {id: event1, format: :js}}.to_not change(Event, :count)
    end

    it 'render destroy template' do
      event = @user.create_event(Date.today, "body body")
      delete :destroy, params: {id: event, format: :js}
      expect(response).to render_template :destroy
    end

    describe "shared event" do
      let!(:user1) { create(:user) }
      let!(:event1) { user1.create_event(Date.today, "new body") }

      before {  event1.share(@user) }

      it 'user can delete' do
        expect {delete :destroy, params: {id: event1, format: :js}}.to change(@user.events, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: {id: event1, format: :js}
        expect(response).to render_template :destroy
      end

    end
  end
  #
  # describe 'PATCH #accept' do
  #   sign_in_user
  #
  #   context "Author of question" do
  #     let!(:question) { create(:question, user: @user) }
  #     let!(:answer) { create(:answer, question: question) }
  #
  #     it 'assigns the requested answer to @answer' do
  #       patch :accept, params: {id: answer, format: :js}
  #       expect(assigns(:answer)).to eq answer
  #     end
  #
  #     it 'change answer accept attribute' do
  #       expect(answer.accept).to eq false
  #       patch :accept, params: {id: answer, format: :js}
  #       answer.reload
  #       expect(answer.accept).to eq true
  #     end
  #
  #     it 'reset accept field of other answers from the question' do
  #       answer2 = create(:answer, question: question, accept: true)
  #       answer3 = create(:answer, question: question, accept: true)
  #
  #       patch :accept, params: {id: answer, format: :js}
  #       answer.reload
  #       answer2.reload
  #       answer3.reload
  #       expect(answer.accept).to eq true
  #       expect(answer2.accept).to eq false
  #       expect(answer3.accept).to eq false
  #     end
  #
  #     it 'render accept template' do
  #       patch :accept, params: {id: answer, format: :js}
  #       expect(response).to render_template :accept
  #     end
  #   end
  #
  #   context "Non-author of question" do
  #     it 'current user is not the author of the question' do
  #       expect(@user).to_not eq question.user
  #     end
  #
  #     it 'assigns the requested answer to @answer' do
  #       patch :accept, params: {id: answer, format: :js}
  #       expect(assigns(:answer)).to eq answer
  #     end
  #
  #     it 'not change answer accept attribute' do
  #       expect(answer.accept).to eq false
  #       patch :accept, params: {id: answer, format: :js}
  #       answer.reload
  #       expect(answer.accept).to eq false
  #     end
  #
  #     it 'not reset accept field of other answers from the question' do
  #       answer2 = create(:answer, question: question, accept: true)
  #       answer3 = create(:answer, question: question, accept: true)
  #
  #       patch :accept, params: {id: answer, format: :js}
  #       answer.reload
  #       answer2.reload
  #       answer3.reload
  #       expect(answer.accept).to eq false
  #       expect(answer2.accept).to eq true
  #       expect(answer3.accept).to eq true
  #     end
  #
  #     it 'redirect to root path' do
  #       patch :accept, params: {id: answer, format: :js}
  #       #expect(response).to render_template :accept
  #       expect(response).to redirect_to root_url
  #     end
  #   end
  # end
  #
  # it_behaves_like "voted" do
  #   let(:object) { answer }
  # end
end
