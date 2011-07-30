module MoviesHelper
  def insert_poster(movie,height)
    if movie.posters.nil? or movie.posters.first.nil?
      image_tag 'no_poster.jpg', :height => height 
    else
      image_tag movie.posters.first.url, :alt => "no image", :height => height
    end
  end
  
  def insert_thumbnail(movie,height)
    if movie.posters.nil? or movie.posters.first.nil?
      image_tag 'no_poster.jpg', :height => height 
    else
      movie.posters.each do |p|
        if p.size == "thumb"
          return image_tag p.url, :alt => "no image", :height => height
        end
      end
    end
    #catch all in case we don't find a thumbnail
    image_tag 'no_poster.jpg', :height => height 
  end
  
  def get_poster_url(movie)
    if movie.posters.nil? or movie.posters.first.nil?
      'no_poster.jpg'
    else
      movie.posters.first.url
    end
  end
  
end
