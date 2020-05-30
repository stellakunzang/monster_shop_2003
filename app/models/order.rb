class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(default pending)

  def self.find_order(order_id)
    Order.find_by(id: order_id)
  end

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def quantity_sum_per_merchant(merchant)
    items.joins(:item_orders).where('items.merchant_id =?', merchant.id).sum('item_orders.quantity')
  end

  def value_sum_per_merchant(merchant)
    items.joins(:item_orders)
         .where('items.merchant_id =?', merchant.id)
         .group('item_orders.quantity')
         .sum('item_orders.price')
         .inject(0) {|result, (key, value)| result += (key * value)}
  end

end
