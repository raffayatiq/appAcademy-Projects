class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	helper_method :current_user
	helper_method :logged_in?
	helper_method :current_session

	def current_user
		return nil if session[:session_token].nil? || current_session.nil?
		@current_user ||= current_session.user
	end

	def current_session
		@current_session ||= Session.find_by(session_token: session[:session_token])
	end

	def login!(user)
		new_session = Session.new(user_id: user.id, device: request.user_agent)
		new_session.session_token = new_session.reset_session_token!
		session[:session_token] = new_session.session_token
	end

	def logged_in?
		!current_user.nil?
	end

	def redirect_if_logged_in
		redirect_to cats_url if logged_in?
	end

	def require_user
		redirect_to new_session_url if !logged_in?
	end

	def authorize_cat_ownership
	  if !user_owns_cat?
	    redirect_to cats_url
	  end
	end

	private
	def user_owns_cat?
	  !current_user.cats.where(user_id: current_user.id).empty?
	end
end
