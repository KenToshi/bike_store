class HomeController < ApplicationController

  before_action :set_user, only: [:update, :delete]

  def index
  end

  def userlist
    @users = User.all
  end

  def signup
  	@user = User.new
  	@type =["User", "Admin"]
  end

  def login
  	@user = User.new
  end

  def logout
  	# routes & view required
  		session[:user_id] = nil
  		redirect_to home_login_path
  end

  def authentication
  	# routes & view required
  	
  	@user = User.authenticate(user_params[:username], user_params[:password])

  	if(@user) # if user found
  		session[:user_id] = @user.id
      respond_to do |format|
      format.html { redirect_to home_index_path }
  		format.json { render json: @user }
      end
   	else # if user not found
  		redirect_to request.referer, :notice => "User not found!"
  	end
  end

  def create
  	@user = User.new(user_params)
  	if(@user.save)
  		redirect_to request.referer, :notice => "New user created!"
  	else
  		redirect_to request.referer, :notice => @user.errors
  	end
  end

  ######################### update ######################### 
  def delete
    @user.destroy
    respond_to do |format|
      format.html { redirect_to request.referer, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  ######################### update ######################### 

  def test
  	
  end

  private
  	def set_user
  		@user = User.find(params[:id])
  	end

  	def user_params
  		params.require(:user).permit(:username, :password, :password_confirmation, :type)
  	end

end
