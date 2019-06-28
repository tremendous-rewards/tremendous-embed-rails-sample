class Product < ActiveRecord::Base
  has_many :skus, class_name: "ProductSku", :dependent => :destroy
end
