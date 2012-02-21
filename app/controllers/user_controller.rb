class UserController < ApplicationController
  before_filter :authenticate_user!
  
  def search
    @attendance = Attendance.new
    @events = current_user.events
    if( params[:search])
      @users = User.find(:all, :conditions => { :username => params[:search] }).paginate(:page => params[:page], :per_page => 15)
    else
      @users = User.all.paginate(:page => params[:page], :per_page => 15)
    end
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])
    if current_user.authorized?(@user.id)
      @user.destroy
      redirect_to(user_index_path, :notice => 'Successfully deleted user')
    else
      action_not_permitted
    end 
  end
  
  def show
    @user = User.find(params[:id])
    @selections = @user.selections.limit(12)
    @votes = @user.votes.limit(12)
    
    if not current_user.authorized?(@user.id)
      action_not_permitted
    end
    
    respond_to do |format|
      format.html
      format.mobile { redirect_to root_path }
    end
  end
 
  private 
    
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end

end
