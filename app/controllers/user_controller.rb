class UserController < ApplicationController
  before_filter :is_admin, :except => [:show,:destroy]
  
  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])
    has_authority(@user.id)
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(user_index_path, :notice => 'Successfully deleted user') }
      format.xml  { head :ok }
    end
  end
  
  def show
    @user = User.find(params[:id])
    has_authority(@user.id)
  end
 
  private 
    def is_admin
      redirect_to(root_path, :notice => 'Not authorized to access that page.') unless current_user.admin?
    end
    
    def has_authority(id)
      redirect_to(root_path, :notice => 'Not authorized to access that page.') unless current_user.admin? or current_user.id == id
    end

end
