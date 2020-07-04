class OrdersController < ApplicationController
  def create
    begin
      raise RangoLivreExceptions::BadParameters if params[:price].nil? || params[:products_id].nil?
      price = params[:price].permit
      products = Product.where(uuid: params[:products_id])
      products_ids = params[:products_id].permit.join(", ")

      raise RangoLivreExceptions::NotFound if products.count != params[:products_id].size
      raise RangoLivreExceptions::CreateConflict if products.select(:restaurant).distinct.pluck(:restaurant).size != 1

      restaurant_name = products.first[:restaurant]

      order = Order.new(price: price, user_uuid: @user[:uuid], restaurant_name: restaurant_name)
      Order.transaction do
        if [1, 2].include?(params[:payment_method].to_i)
          
        end
      end


    rescue RangoLivreExceptions::NotFound
      render json: { error: 'Not Found' }, status: 404
    rescue RangoLivreExceptions::CreateConflict
      render json: { error: 'Conflict' }, status: 409
    rescue RangoLivreExceptions::BadParameters
      render json: {error: 'Bad parameters'}, status: 422
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end
  def index
    begin
      
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end
  
  
end