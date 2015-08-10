# class SessionsController < ApplicationController
	# def new
	# end

	# def create
	# 	user = User.find_by_email(params[:session][:email])
	# 	if user && :authenticate_user!
	# 		sign_in user
	# 		redirect_back_or user
	# 	else
	# 		flash.now[:error] = 'Invalid email/password combination'
	# 		render 'new'
	# 	end
	# end
	
	# def destroy
	# 	sign_out
	# 	redirect_to root_path
	# end
# end