class TransactionsController < ApplicationController
	def create
		begin
			transaction = Transaction.new(create_transaction_params)
			raise RangoLivreExceptions::BadParameters if (!transaction.valid?) || (params[:scheduled] == true && timestamp.nil?)

			
			# user = User.find_by(CPF: params[:to_CPF])
			# check_if_enough_funds(user) if params[:transaction_type].to_i == 1 
			# params.permit(:amount)
			# Transaction.transaction do
			# 	transaction[:responsible_id] = @user[:id]
			# 	transaction.save!
			# 	raise RangoLivreExceptions::NotFound if user.nil?
			# 	if params[:transaction_type] == 0
			# 		amount = params[:amount]
			# 	elsif params[:transaction_type] == 1
			# 		amount = - params[:amount]
			# 	else
			# 		raise RangoLivreExceptions::BadParameters
			# 	end
			# 	if params[:account_type] == 0
			# 		user.update(regular_balance: user[:regular_balance] + amount)
			# 	elsif params[:account_type] == 1
			# 		user.update(regular_balance: user[:meal_allowance_balance] + amount)
			# 	else
			# 		raise RangoLivreExceptions::BadParameters
			# 	end
				
			# end
			
			render json: {transaction: transaction.json_object}, status: 201
		rescue RangoLivreExceptions::NotFound
			render json: { error: 'User not found' }, status: 404
		rescue RangoLivreExceptions::CreateConflict
			render json: { error: "Not enough funds" }, status: 409
		rescue RangoLivreExceptions::BadParameters
			render json: { error: 'Bad parameters'}, status: 422
		rescue RangoLivreExceptions::UnauthorizedOperation
			render json: { error: 'Unauthorized token' }
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end
	def index
		begin
			raise RangoLivreExceptions::BadParameters if (params[:offset].nil? || params[:limit].nil?)

			transactions = Transaction.where(to_CPF: @user[:CPF])
			total = transactions.count
			transactions = transactions.offset(offset).limit(limit)

			transactions = transactions.each {|x| x.json_object}

			render json: {
				transactions: transactions, 
				total: total,
				limit: limit,
				offset: offset
			}
		rescue RangoLivreExceptions::BadParameters
			render json: { error: 'Bad parameters'}, status: 422
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end	
	end
	def destroy
		begin
			transaction = Transaction.find_by(uuid: params[:id])			

			raise RangoLivreExceptions::NotFound if transaction.nil?
			raise RangoLivreExceptions::Forbidden if (transaction[:from_CPF] != @user[:CPF]) || transaction[:timestamp] >= Time.now.to_i

			transaction.destroy

			render status: 204
		rescue RangoLivreExceptions::Forbidden
			render json: {error: "Forbidden"}, status: 403
		rescue RangoLivreExceptions::NotFound
			render json: {error: "Not found"}, status: 404
		rescue => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join("\n")
			render status: 500
		end
	end

	private
	
	def check_if_enough_funds(user)
		case params[:account_type].to_i
		when 0
			if !(user[:regular_balance] >= params[:amount])
				raise RangoLivreExceptions::CreateConflict
			end
		when 1
			if !(user[:meal_allowance_balance] >= params[:amount])
				raise RangoLivreExceptions::CreateConflict
			end
		else
			raise RangoLivreExceptions::BadParameters
		end
	end
	
	def create_transaction_params
		params.permit(:amount, :transaction_type, :account_type, :from_CPF, :to_CPF, :scheduled, :timestamp)
	end
	
    
end