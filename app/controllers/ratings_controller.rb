class RatingsController < ApplicationController
  def create
    begin
      raise RangoLivreExceptions::BadParameters if params[:product_uuid].nil? || params[:rating]

      product = Product.find_by(uuid: params[:product_uuid])
      raise RangoLivreExceptions::NotFound if product.nil?

      params.permit(:rating, :product_uuid)
      total_ratings = product[:total_ratings] + 1
      if total_ratings == 1
        average_rating = params[:rating]
      else
        average_rating = (product[:average_rating]*(product[:total_ratings]-1) + params[:rating].to_f)/total_ratings
      end
      product.update(average_rating: average_rating, total_ratings: total_ratings)
      UserRating.create(user_id: @user[:id], product_id: product[:id], average_rating: average_rating)
      render status: 204
    rescue RangoLivreExceptions::NotFound
      render json: { error: 'Not found' }, status: 404
    rescue RangoLivreExceptions::BadParameters
      render json: { error: 'Bad parameters'}, status: 422
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      render status: 500
    end
  end  
end