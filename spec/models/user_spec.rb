require 'rails_helper'
require 'spec_helper'

describe User do

  subject { User.create }

  it { expect(subject.balance).to eq 0 }
  it { expect(subject.created_at).to_not eq nil }
  it { expect(subject.updated_at).to_not eq nil }
  it { expect(subject.items).to be_a ActiveRecord::Associations::CollectionProxy }

  context 'given a bunch of items' do

    before :each do
      subject.items.create(item_type: 'fee', amount: 200.0, date: '2015-05-10')
      subject.items.create(item_type: 'fee', amount: 50.0, date: '2015-05-10')
      subject.items.create(item_type: 'fee', amount: 12.0, date: '2015-05-10')
      subject.items.create(item_type: 'payment', amount: 20.0, date: '2015-05-10')
      subject.items.create(item_type: 'payment', amount: 130.5, date: '2015-05-10')
      subject.items.create(item_type: 'payment', amount: 64.0, date: '2015-05-10')
    end

    it 'should return only fees' do
      expect(subject.items.fees.map(&:item_type)).to eq ['fee', 'fee', 'fee']
    end

    it 'should return only payments' do
      expect(subject.items.payments.map(&:item_type)).to eq ['payment', 'payment', 'payment']
    end

    it 'should calculate the balance' do
      expect(subject.balance).to eq 0
      expect(subject.process_balance).to eq -47.5
      expect(subject.balance).to eq -47.5
    end

  end
end