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
    orders_with_data = Hash.new { |hash, key| hash[key] = {date: 0, quantity_sum: 0, price_sum: 0} }
    find_quantities.each do |id, quantity|
      orders_with_data[id][:quantity_sum] = quantity
      orders_with_data[id][:date] = Order.find_by(id: id).created_at.strftime('%m/%d/%Y')
    end
    find_prices.each do |id, price|
      orders_with_data[id][:price_sum] = price
    end
    orders_with_data
  end

  def find_prices
    items.joins(:item_orders, :orders)
         .select('orders.id, item_orders.price, items.merchant_id')
         .where('items.merchant_id =?', self.id)
         .group('item_orders.order_id')
         .sum('item_orders.price')
  end

  def find_quantities
    items.joins(:item_orders, :orders)
         .select('orders.id, item_orders.quantity, orders.created_at, items.merchant_id')
         .where('items.merchant_id =?', self.id)
         .group('item_orders.order_id')
         .sum('item_orders.quantity')
  end
end
