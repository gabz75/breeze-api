require 'rails_helper'
require 'spec_helper'

module V1
  describe ItemsController do
    let (:user) { User.create }

    describe ':create' do
      it 'should return 201' do
        post :create, user_id: user.id, item_type: 'payment', amount: 20.0

        expect(response).to be_successful
        expect(response.status).to eq 201
      end

      it 'should return 404' do
        post :create, user_id: 0, item_type: 'payment', amount: 20.0

        expect(response).to_not be_successful
        expect(response.status).to eq 404
      end

      it 'should return 422' do
        post :create, user_id: user.id, item_type: 'wrong-type', amount: 20.0

        expect(response).to_not be_successful
        expect(response.status).to eq 422

        json = JSON.parse(response.body)

        expect(json['errors']).to_not be_nil
        expect(json['errors']['item_type']).to_not be_nil
      end
    end
  end
end