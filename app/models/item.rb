class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.top_5
    top_5_data = ItemOrder.find_by_sql ["SELECT items.name, item_id, SUM(quantity) AS total_purchased FROM item_orders JOIN items ON item_orders.item_id = items.id GROUP BY item_id, items.name ORDER BY total_purchased DESC LIMIT 5"]
    # Item.joins(:item_orders)
    #     .select('items.id, items.name, sum(item_orders.quantity)')
    #     .group('items.id')
    #     .order('sum(item_orders.quantity)')
    #     .limit(5)
    keys = top_5_data.pluck(:name)
    values = top_5_data.pluck(:total_purchased)
    top_5 = Hash[keys.zip(values)]
  end

  def self.worst_5
    worst_5_data = ItemOrder.find_by_sql ["SELECT items.name, item_id, SUM(quantity) AS total_purchased FROM item_orders JOIN items ON item_orders.item_id = items.id GROUP BY item_id, items.name ORDER BY total_purchased LIMIT 5"]
    keys = worst_5_data.pluck(:name)
    values = worst_5_data.pluck(:total_purchased)
    worst_5 = Hash[keys.zip(values)]
  end

end
