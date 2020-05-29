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

  def orders_with_my_items
    x = items.joins(:item_orders, :orders)
         .select('orders.id, orders.created_at, item_orders.price, item_orders.quantity')
         .group('item_orders.order_id')
         .sum('item_orders.price')
         # currently returns sum of price of items without first getting sum of quantity! returns a hash with order_id => price
         binding.pry
  end

end
