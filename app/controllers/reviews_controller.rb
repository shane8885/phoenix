class ReviewsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @review = Review.new(params[:review])
    # can only review a selection for an event you're invited to
    if current_user.invited_to?(@review.selection.event)
      if @review.save
        redirect_to @review.selection, :notice => "Successfully added your review."
      else
        # set some stuff up so we can re-render the form
        @rating = @review.rating
        @selection = @review.selection
        render 'selections/add_review'
      end
    else
      action_not_permitted
    end
  end
  
  def edit
    @review = Review.find(params[:id])
    @selection = @review.selection
    @rating = @review.rating
    # can only edit your own review
    if(current_user.authorized?(@review.user_id))
      render 'selections/add_review'
    else
      action_not_permitted
    end
  end
  
  def update
    @review = Review.find(params[:id])
    # can only update your own review
    if current_user.authorized?(@review.user_id)
      if @review.update_attributes(params[:review])
        redirect_to @review.selection, :notice => "Successfully updated your review." 
      else
        # set some stuff up so we can re-render the form
        @rating = @review.rating
        @selection = @review.selection
        render 'selections/add_review'
      end
    else
      action_not_permitted
    end
  end
  
  def destroy
    review = Review.find(params[:id])
    selection = review.selection
    # can only delete your own review
    if current_user.authorized?(review.user_id)
      review.destroy
      redirect_to selection, :notice => 'Successfully deleted review.'
    else
      action_not_permitted
    end
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :alert => 'Not authorized to perform that action.')
    end
end
