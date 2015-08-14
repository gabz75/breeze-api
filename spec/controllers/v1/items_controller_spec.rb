require 'rails_helper'
require 'spec_helper'

module V1
  describe ItemsController do
    let (:user) { User.create }

    describe ':create' do
      it 'should return 201' do
        post :create, user_id: user.id, item_type: 'payment', amount: 20.0, date: '2015-10-10'

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

      it 'charge late for late fee' do
        allow_any_instance_of(User).to receive(:move_or_create_to_list).and_return(true)

        post :create, user_id: user.id, item_type: 'fee', amount: 500, date: '2015-08-10'

        expect(response.status).to eq 201
        expect(user.reload.balance).to eq -500.0

        post :create, user_id: user.id, item_type: 'payment', amount: 500, date: '2015-08-10'

        expect(response.status).to eq 201
        expect(user.reload.balance).to eq 0

        post :create, user_id: user.id, item_type: 'fee', amount: 500, date: '2015-08-11'

        expect(response.status).to eq 201
        expect(user.reload.balance).to eq -500.0

        post :create, user_id: user.id, item_type: 'payment', amount: 500, date: '2015-08-15'

        expect(response.status).to eq 201
        expect(user.reload.balance).to eq -20.0
      end
    end
  end
end