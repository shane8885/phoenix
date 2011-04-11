module MoviesHelper
  def insert_poster(movie,height)
    if movie.posters.nil? or movie.posters.first.nil?
      image_tag 'no_poster.jpg', :height => height 
    else
      image_tag movie.posters.first.url, :alt => "no image", :height => height
    end
  end
  
  def get_poster_url(movie)
    if movie.posters.nil? or movie.posters.first.nil?
      'no_poster.jpg'
    else
      movie.posters.first.url
    end
  end
  
end
