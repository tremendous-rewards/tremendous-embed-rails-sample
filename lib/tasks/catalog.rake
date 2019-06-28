task :products_update => :environment do
  $tremendous_rest_client.products.list.map do |product|
    item = Product.find_or_create_by(tremendous_id: product.raw[:id]) do |item|
      item.name = product.raw[:name]
      item.category = product.raw[:category].try(:upcase)
      item.countries = product.raw[:countries]
    end

    product.raw[:skus].map do |sku|
      ProductSku.find_or_create_by({
        product_id: item.id,
        min: sku[:min],
        max: sku[:min],
      })
    end
  end
end

task :catalog_destroy => :environment do
  Product.all.destroy_all
end
