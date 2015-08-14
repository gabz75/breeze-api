class User < ActiveRecord::Base

  has_many :items

  def process_balance
    b = items.payments.inject(0) { |sum, p| sum + p.amount } - items.fees.inject(0) { |sum, f| sum + f.amount }
    update(balance: b)
    b
  end

  OPEN_LIST = '54ee82fe28c214334d9e10ec'
  RESOLVED_LIST = '54ee82ff6d371d305a8f7ee7'
  BOARD_ID = '54ee82fae62c0eb8da6d3115'
  LATE_FEE = 5.0

  def charge_late_fee(days)
    items.create(item_type: 'fee', amount: LATE_FEE * days, date: Time.now)
    update(balance: balance - LATE_FEE * days)
  end

  def mark_as_delinquent
    update(delinquent: true, last_delinquent_at: Time.now)
    move_or_create_to_list(OPEN_LIST)
  end

  def mark_as_clean
    update(delinquent: false)
    move_or_create_to_list(RESOLVED_LIST)
  end

  def move_or_create_to_list(list_id)
    if trello_card
      Trello::Card.find(trello_card).move_to_list(list_id)
    else
      card = Trello::Card.create(list_id: list_id, name: "user##{ id }")
      update(trello_card: card.id)
    end
  end

end