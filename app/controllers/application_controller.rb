class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :current_user
  

  private
  	def current_user
      current_uri = request.env['PATH_INFO']
  		if(session[:user_id]) 
        @current_user = User.find(session[:user_id])

        if(current_uri == home_userlist_path && @current_user.user_type != "Admin")
          redirect_to home_index_path
        end
  		else
        if request.format.json?
        elsif (current_uri != home_login_path && current_uri != home_authentication_path)
            redirect_to home_login_path, :notice  => "Please Login First"               
        end
      end
  	end

end
