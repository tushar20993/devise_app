class UsersController < ApplicationController

before_action :signed_in_user, only: [:index, :show, :following, :followers]
	
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def show
		@user = User.find(params[:id])
    		@microposts = @user.microposts
  	end
  	
  	def following
  		@title = "Following"
  		@user = User.find(params[:id])
  		@users = @user.followed_users.paginate(page: params[:page])
  		render 'show_follow'
  	end

  	def followers
  		@title = "Followers"
  		@user = User.find(params[:id])
  		@users = @user.followers.paginate(page: params[:page])
  		render 'show_follow'
  	end
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_url) unless current_user?(@user)
  	end
  	
  	
  private
  
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
                end
   
   
        def signed_in_user
        	unless user_signed_in?
        		strore_location
        		redirect_to new_user_session_path, notice: "Please sign in"
        	end
        end
   
  
end
