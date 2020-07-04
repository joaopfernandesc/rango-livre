class ProductsController < ApplicationController
	before_action :authorized, only: []

	def create
		begin
			product = Product.create(create_params)
			if !product.valid?
				raise RangoLivreExceptions::BadParameters
			end

			render json: {product: product.json_object}, status: 201
		rescue RangoLivreExceptions::BadParameters
			render json: { error: "Bad parameters" }, status: 422
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
		end
	end
	def index
		begin
			raise RangoLivreExceptions::BadParameters if (params[:offset].nil? || params[:limit].nil? || params[:city].nil?)

			city = params[:city].gsub(/[^0-9A-Za-z]/, '')
			offset = params[:offset]
			limit = params[:limit]

			products = Product.where('lower(city) = ?', city.downcase)
			total = products.count
			products = products.offset(offset).limit(limit)

			products = products.map {|x| x.json_object}

			render json: {
				products: products,
				offset: offset,
				limit: limit,
				total: total,
				city: city
			}, status: 200
		rescue RangoLivreExceptions::BadParameters
			render json: {error: "Bad parameters"}, status: 422
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
		end
	end
	def show
		begin
			product_uuid = params[:id]

			product = Product.find_by(uuid: product_uuid)

			raise RangoLivreExceptions::NotFound if product.nil?

			render json: {product: product.json_object}, status: 200
		rescue RangoLivreExceptions::NotFound
			render json: { error: "Not found"}, status: 404
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end
	
	private
	
	def create_params
		params.permit(:image, :name, :category, :actual_price, :restaurant, :regular_price, :discount, :description,  :min_estimative, :max_estimative, :city, :delivery_fare)
	end
end