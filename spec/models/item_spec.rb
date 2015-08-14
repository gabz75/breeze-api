require 'rails_helper'
require 'spec_helper'

describe Item do

  let(:user) { User.create }

  it 'should have mandotory attributes' do
    errors = user.items.create.errors
    expect(errors).to include :amount
    expect(errors).to include :item_type
  end

  it 'should have restricted types' do
    expect(user.items.create(amount: 0, date: '2015-01-01', item_type: 'wrong')).to_not be_persisted
    expect(user.items.create(amount: 0, date: '2015-01-01', item_type: 'fee')).to be_persisted
    expect(user.items.create(amount: 0, date: '2015-01-01', item_type: 'payment')).to be_persisted
  end
end