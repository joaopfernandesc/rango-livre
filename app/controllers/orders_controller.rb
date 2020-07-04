class OrdersController < ApplicationController
  def create
    begin
      raise RangoLivreExceptions::BadParameters if params[:price].nil? || params[:products_id].nil?
      price = params[:price].permit
      uuid_products = params[:products].map { |x| x[:uuid]}
      products = Product.where(uuid: uuid_products)

      raise RangoLivreExceptions::NotFound if products.count != uuid_products.size
      raise RangoLivreExceptions::CreateConflict if products.select(:restaurant).distinct.pluck(:restaurant).size != 1

      restaurant_name = products.first[:restaurant]

      order = Order.new(price: price, user_uuid: @user[:uuid], restaurant_name: restaurant_name)
      Order.transaction do
        raise RangoLivreExceptions::BadParameters if !order.valid?
        order.save!
        case params[:payment_method].to_i
        when 0          
          raise RangoLivreExceptions::CreateConflict if params[:price] > user[:regular_balance]
          Transaction.create(order_id: order[:id], amount: price, transaction_type: 1, account_type: params[:payment_method].permit, from_CPF: @user[:CPF], to_CPF: "0", timestamp: Time.now.to_i)
          @user.update(regular_balance: @user[:regular_balance] - price)
        when 1          
          raise RangoLivreExceptions::CreateConflict if params[:price] > user[:meal_allowance_balance]
          Transaction.create(order_id: order[:id], amount: price, transaction_type: 1, account_type: params[:payment_method].permit, from_CPF: @user[:CPF], to_CPF: "0", timestamp: Time.now.to_i)
          @user.update(meal_allowance_balance: @user[:meal_allowance_balance] - price)
        when 2
          # Do nothing
        else
          raise RangoLivreExceptions::BadParameters
        end

        order_products = products.map { 
          |x| 
          {
            product_id: x[:id],
            quantity: (params[:products].select { |y| y[:uuid] == x[:uuid] }).first[:quantity]
            order_id: order[:id]
          }
        }

        OrderProduct.create(order_products)
      end

      render json: {order: order.json_object}, status: 201
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
      raise RangoLivreExceptions::BadParameters
      offset = params[:offset]
      limit = params[:limit]

      orders = Order.where(user_uuid: @user[:uuid])
      total = orders.count
      display = orders.offset(offset).limit(limit).map { order.json_object }

      render json: {
        orders: display,
        total: total,
        offset: offset,
        limit: limit
      }, status: 200
    rescue RangoLivreExceptions::BadParameters
      render status: 422
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end
  
  
end