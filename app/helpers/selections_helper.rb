module SelectionsHelper
  def myreview
    if review = current_user.reviews.find_by_selection_id(params[:id])
        link_to 'update my review', edit_review_path(review)
    else
        link_to 'review it', :controller => 'reviews', :action => 'new', :selection_id => params[:id]
    end
  end
  
  def get_star(n)
    s = Selection.find(params[:id])
    if avg = s.average_rating
      # round to nearest 0.5
      avg = (avg*2).round.to_f / 2
      if n <= avg
        image_tag('star-bright.png')
      else
        if avg == (n - 0.5)
          image_tag('star-half.png')
        else
          image_tag('star-dim.png')
        end
      end
    else
      image_tag('star-dim.png')
    end
  end
end
