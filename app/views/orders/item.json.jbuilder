json.array!(@order_items) do |order_item|
  json.extract! order_item, :id, :product_id, :order_id, :qty, :price
  json.product_name order_item.product.bike_name
  json.current_stock order_item.product.stock.qty
end
