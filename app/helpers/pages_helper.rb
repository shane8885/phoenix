module PagesHelper
  def insert_poster(movie,height)
    if movie.posters.nil? or movie.posters.first.nil?
      image_tag 'no_poster.jpg', :height => height 
    else
      image_tag movie.posters.first.url, :alt => "no image", :height => height
    end
  end
end
