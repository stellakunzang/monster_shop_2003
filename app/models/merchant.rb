class Merchant <ApplicationRecord
  has_many :users
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :active?

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def merchant_orders
    items.joins(:orders).where('status =?', 0).distinct.pluck('order_id')
  end

  def my_item_orders(order_id)
    item_orders.joins(:item).where('order_id = ? AND items.merchant_id = ?', order_id, self.id)
  end

end
