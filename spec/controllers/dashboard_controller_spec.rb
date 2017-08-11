require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  #let(:question) { create(:question) }

  describe 'GET #index' do

    describe "with authenticate user" do
      sign_in_user

      let!(:events) { create_list(:event, 5, owner: @user) }
      subject { get :index }

      it 'renders index view' do
        subject
        expect(response).to render_template :index
      end
    end

    describe "with non-authenticate user" do
      it 'redirect to sign in' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
