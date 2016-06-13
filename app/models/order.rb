 class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_item, dependent: :destroy
  
  before_create :set_initial_status
  before_destroy :check_credentials
  
  validates :customer_id, presence: true
  
  enum status: [:pre_order, :active_order, :finished, :cancelled]
  enum shipping_method: [:on_the_spot, :delivery]

  accepts_nested_attributes_for :customer, :order_item
  
  def set_initial_status
    self.is_paid = false
    self.is_delivered = false
    self.status = 0
  end 
  
end
