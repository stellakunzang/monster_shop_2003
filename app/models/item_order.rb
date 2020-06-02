class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def fulfill
    update(fulfilled?: true)
  end

  def cancel_order
    if fulfilled?
      item.update(inventory: (item.inventory + quantity))
      update(fulfilled?: false)
    end
  end
end
