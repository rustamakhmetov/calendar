require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe "PATCH #view" do
    let!(:user1) { create(:user) }
    let!(:event) { user1.create_event(Date.today, "text text") }

    subject { patch :view, params: { id: event.id }, format: :js }

    sign_in_user
    before { event.share(@user) }

    it "assigns event to @event" do
      subject
      expect(assigns("event")).to eq event
    end

    it "change viewed to true" do
      expect(event.viewed?(@user)).to eq false
      subject
      expect(event.viewed?(@user)).to eq true
    end

    it 'render template view' do
      subject
      expect(response).to render_template :view
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new event to database' do
        expect { post :create, params: { event: attributes_for(:event) }, format: :js }.to change(@user.events, :count).by(1)
      end

      it 'current user link to the new event' do
        post :create, params: { event: attributes_for(:event), format: :js }
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

      it "user don't delete" do
        expect {delete :destroy, params: {id: event1, format: :js}}.to_not change(@user.events, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: {id: event1, format: :js}
        expect(response).to_not render_template :destroy
      end
    end
  end

  describe 'PATCH #share' do
    sign_in_user

    let!(:user1) { create(:user) }
    let!(:event) { @user.create_event(Date.today, "new event") }

    describe "with valid attributes" do
      subject { patch :share, params: { id: event, event: { email:user1.email }, format: :js } }

      it 'assigns the requested event to @event' do
        subject
        expect(assigns(:event)).to eq event
      end

      it "event saved to the users's event collection" do
        expect { subject }.to change(user1.events, :count).by(1)
      end

      it 'render share template' do
        subject
        expect(response).to render_template :share
      end
    end

    describe "with invalid attributes" do
      subject { patch :share, params: { id: event, event: { email: nil }, format: :js } }

      it 'assigns the requested event to @event' do
        subject
        expect(assigns(:event)).to eq event
      end

      it "event don't saved to the users's event collection" do
        expect { subject }.to_not change(user1.events, :count)
      end

      it 'render share template' do
        subject
        expect(response).to render_template :share
      end
    end
  end
end
