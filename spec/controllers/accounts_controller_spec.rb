require 'rails_helper'

RSpec.describe AccountsController, type: :controller do

  context 'logged in as admin' do
    login_admin

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "sets @accounts" do
        users = 3.times.map { FactoryGirl.create(:user) }
        get :index
        expect(assigns[:accounts].to_a).to match_array(users)
      end
    end

    describe "GET #show" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_admin) { FactoryGirl.create(:admin) }

      context 'when retrieving user account' do
        before :each do
          get :show, id: user.id
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "sets @account" do
          expect(assigns[:account]).to eq(user)
        end
      end

      context 'when retrieving admin account' do
        it "returns http success" do
          expect {
            get :show, id: other_admin.id
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "GET #edit" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_admin) { FactoryGirl.create(:admin) }

      before do
        # Braintree::Plan is not currently supported in fake_braintree
        fake_plan = Struct.new(:id, :price, :billing_frequency)
        expect(Braintree::Plan).to receive(:all) { 5.times.map {|i| fake_plan.new("id_#{i}", 55, 2)} }
      end

      context 'when retrieving user account' do
        before :each do
          get :edit, id: user.id
        end

        it "returns http success" do
          puts response.body
          expect(response).to have_http_status(:success)
        end

        it "sets @account" do
          expect(assigns[:account]).to eq(user)
        end
      end
    end

    describe "PUT #update" do
      pending "Need to add specs"
    end
  end

  context 'logged in as user' do
    login_user

    describe "GET #index" do
      it "not authorized" do
        get :index
        expect_user_not_authorized
      end
    end

    describe "GET #show" do
      it "not authorized" do
        get :show, id: signed_in_user.id
        expect_user_not_authorized
      end
    end

    describe "GET #edit" do
      it "not authorized" do
        get :edit, id: signed_in_user.id
        expect_user_not_authorized
      end
    end
  end


end
