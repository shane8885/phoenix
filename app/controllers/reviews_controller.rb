class ReviewsController < ApplicationController
  before_filter :authenticate_user!

  def create
    review = Review.new(params[:review])
    if current_user.invited_to?(review.selection.event)
      if review.save
        respond_to do |format|
          format.html { redirect_to review.selection, :notice => "Successfully added your review." }
          format.js
        end
      else
        redirect_to review.selection, :alert => 'Sorry, failed to create review.'
      end
    else
      action_not_permitted
    end
  end

  def new
    @selection = Selection.find(params[:selection_id])
    @review = Review.new
    @rating = 0
  end
  
  def edit
    @review = Review.find(params[:id])
    @selection = @review.selection
    @rating = @review.rating
    render 'new'
  end
  
  def update
    review = Review.find(params[:id])
    if current_user.invited_to?(review.selection.event)
      if review.update_attributes(params[:review])
        redirect_to review.selection, :notice => "Successfully updated your review." 
      else
        redirect_to review.selection, :alert => "Sorry, failed to update your review." 
      end
    else
      action_not_permitted
    end
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :alert => 'Not authorized to perform that action.')
    end
end
