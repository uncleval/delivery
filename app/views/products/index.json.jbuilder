json.products do
  json.array! @products do |product|
    json.extract! product, :title
    json.price number_to_currency(product.price)
  end
end
