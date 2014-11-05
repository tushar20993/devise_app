class MicropostsController < ApplicationController
   
before_action :correct_user, only: :destroy
	
  def index
  end

  def show
	@thing = Micropost.find(params[:id])
	@micropost_item = @thing.content
	
	if (@thing.avatar != nil)
		@micropost_avatar = @thing.avatar
	end
	
  end

  def create
  	  @micropost = current_user.microposts.build(micropost_params)
  	  if @micropost.save
  	  	  flash[:success] = "Micropost created!"
  	  	  redirect_to '/'
  	  else
  	  	  @feed_items = []
  	  	  render 'static_pages/home'
  	  end
  end

  def destroy
  	  @micropost.destroy
  	  redirect_to root_url
  end

  private

  def micropost_params
  params.require(:micropost).permit(:content,:avatar)
  end
  
  def correct_user
  	  @micropost = current_user.microposts.find_by(id: params[:id])
  	  redirect_to root_url if @micropost.nil?
  end
end
