class HomeController < ApplicationController

  before_action :set_user, only: [:update, :delete]
  skip_before_filter :verify_authenticity_token
  
  def index
    @orders = Order.all
  end

  def userlist
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
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

  def change_password    
    @user=  User.find(session[:user_id])
    
  end

  def verify_change_password
    @user = User.authenticate(user_params[:username], user_params[:old_password])

    @password = user_params[:password]
    @password_confirmation = user_params[:password_confirmation]

    if(@user)

      if(@password == @password_confirmation)
        
        if (@user.update(user_params))
          respond_to do |format|    
            format.json { render json: {message: "password successfully updated!"}, status: :accepted  }
          end
        else
          respond_to do |format|    
            format.json { render json: {errors: @user.errors}, status: :unprocessable_entity  }
          end
        end

      else
        
        respond_to do |format|    
            format.json { render json: {errors: {password_confirmation: "password confirmation required!"}}, status: :unprocessable_entity  }
        end
      end
      
    else
      respond_to do |format|
        format.json { render json: {errors: {old_password: "doesn't match!"}}, status: :unprocessable_entity }      
      end
    end
    
  end

  def authentication
  	# routes & view required
  	@user = User.authenticate(user_params[:username], user_params[:password])

  	if(@user) # if user found
  		session[:user_id] = @user.id
      respond_to do |format|
    		format.json { render json: @user, status: :ok }
      end
   	else # if user not found
      respond_to do |format|
        format.json { render json: {errors: "Username or Password is not found"}, status: :unprocessable_entity}
      end
  	end
  end

  def create
  	@user = User.new(user_params)
  	if(@user.save)
      respond_to do |format|
        format.json { render json: {message: 'User successfully created!'}, status: :created }
      end
  	else
      respond_to do |format|
        format.json { render json: {errors: @user.errors }, status: :unprocessable_entity }
      end  		
  	end
  end

  ######################### update ######################### 
  def delete
    @user = User.find(params[:id])
    if(@user.user_type=="Admin")
      respond_to do |format|        
        format.json { render json: {message: 'Admin cannot be deleted'}, status: :forbidden }
      end
    else 
      @user.destroy
      respond_to do |format|      
        format.json { render json: {message: 'User was successfully deleted'}, status: :accepted }
      end
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
  		params.require(:user).permit(:username, :old_password, :password, :password_confirmation, :user_type)
  	end

end
