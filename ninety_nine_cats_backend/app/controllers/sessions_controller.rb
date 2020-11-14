class SessionsController < ApplicationController
	before_action :redirect_if_logged_in, except: [:destroy]

	def new
		@user = User.new
		render :new
	end

	def create
		username = params[:user][:username]
		password = params[:user][:password]

		user = User.find_by_credentials(username, password)

		if user.nil?
			flash.now[:errors] = ["Invalid username or password."]
			@user = User.new
			@user.username = username
			@user.password = password
			render :new
		else
			login!(user)
			redirect_to cats_url
		end
	end

	def destroy
		if !current_user.nil?
			session_to_destroy = Session.find_by(id: params[:id])
			session[:session_token] = nil if current_session == session_to_destroy
			session_to_destroy.destroy
			redirect_to new_session_url
		end
	end
end