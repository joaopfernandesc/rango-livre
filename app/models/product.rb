class Product < ApplicationRecord
	acts_as_paranoid
	mount_uploader :image, ProductUploader
	before_create :set_uuid

	validates :image, :delivery_fare, :name, :category, :actual_price, :regular_price, :discount, :min_estimative, :max_estimative, :city, :restaurant, presence: true

	def set_uuid
		self.uuid = SecureRandom.uuid
	end
	
	def json_object
		{
			uuid: uuid,
			image: image.url,
			name: name,
			actual_price: actual_price,
			regular_price: regular_price,
			discount: discount,
			description: description,
			restaurant: restaurant,
			min_estimative: min_estimative,
			max_estimative: max_estimative,
			city: city,
			delivery_fare: delivery_fare,
			average_rating: average_rating,
			total_ratings: total_ratings
		}
	end
    
end
