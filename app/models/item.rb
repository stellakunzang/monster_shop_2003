class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: -1
  validates_numericality_of :inventory, greater_than: -1

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def update_inventory(quantity)
    update_attributes(inventory: (inventory - quantity))
  end

  def default_image
    self.image = "https://images.freeimages.com/images/large-previews/c72/banana-2-1330039.jpg"
    self.save
  end

  def self.top_5
    Item.joins(:item_orders)
        .where(active?: true)
        .group('items.name')
        .order('sum(item_orders.quantity) desc')
        .limit(5)
        .sum('item_orders.quantity')
  end

  def self.worst_5
    Item.joins(:item_orders)
        .where(active?: true)
        .group('items.name')
        .order('sum(item_orders.quantity)')
        .limit(5)
        .sum('item_orders.quantity')
  end

end
