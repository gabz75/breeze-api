class Item < ActiveRecord::Base

  belongs_to :user

  validates :item_type, presence: true, format: /\Apayment|fee\z/
  validates :amount, presence: true

  scope :fees, -> { where(item_type: 'fee') }
  scope :payments, -> { where(item_type: 'payment') }

end