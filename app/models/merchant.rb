class Merchant <ApplicationRecord
  has_many :users
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


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

  def orders_with_my_items
    item_orders.joins(:order)
          .select('orders.id, sum(item_orders.price), sum(item_orders.quantity)')
          .where('item_orders.merchant_id =?', self.id)
          .group('items_orders.order_id')
  end

end
