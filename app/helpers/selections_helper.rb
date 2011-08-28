module SelectionsHelper
  def myreview
    if review = current_user.reviews.find_by_selection_id(params[:id])
        link_to 'update my review', edit_review_path(review)
    else
        link_to 'review it', add_review_selection_path(@selection)
    end
  end
  
  def get_stars(s,opts={})
    height = 25
    html = ''
    if opts[:small]
      height = 15
    end
    avg = s.average_rating
    # round to nearest 0.5
    avg = (avg*2).round.to_f / 2
    for i in (1..10)
      if i <= avg
        html << image_tag('star-bright.png',:height => height)
      else
        if avg == (i - 0.5)
          html << image_tag('star-half.png',:height => height)
        else
          html << image_tag('star-dim.png',:height => height)
        end
      end
    end
    html.html_safe
  end
end
