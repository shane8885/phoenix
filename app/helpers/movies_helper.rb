module MoviesHelper
  def insert_poster(movie,height)
    if movie.posters.nil? or movie.posters.first.nil?
      image_tag 'no_poster.jpg', :height => height 
    else
      movie.posters.each do |p|
        if p.size == "cover"
          return image_tag p.url, :alt => "no image", :height => height
        end
      end
    end
    #catch all, fallback to default no poster image 
    image_tag 'no_poster.jpg', :height => height 
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
  
  def get_thumb_url(movie)
    if movie.posters.nil? or movie.posters.first.nil?
      'no_poster.jpg'
    else
      movie.posters.each do |p|
        if p.size == "thumb"
          return p.url
        end
      end
    end
    #catch all in case we don't find a thumbnail
    'no_poster.jpg'
  end
end
