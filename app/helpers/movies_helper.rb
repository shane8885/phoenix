module MoviesHelper
  def insert_poster(movie,height)
    if movie.class == Hash
      if movie['poster_path']
        return image_tag("#{@tmdb.base_url}w500#{movie['poster_path']}", :height => height)
      end
    else
      if movie.poster_path
        return image_tag("#{@tmdb.base_url}w500#{movie.poster_path}", :height => height)
      end
    end
    image_tag 'no_poster.jpg', :height => height 
  end
  
  def insert_thumbnail(movie,height)
    if movie.class == Hash
      if movie['poster_path']
        return image_tag("#{@tmdb.base_url}w92#{movie['poster_path']}", :height => height, :title => movie['title'])
      end
    else
      if movie.poster_path
        return image_tag("#{@tmdb.base_url}w92#{movie.poster_path}", :height => height, :title => movie.title)
      end
    end
    image_tag 'no_poster.jpg', :height => height 
  end
  
  def person_thumbnail(person,height)
    if person.class == Hash
      if person['profile_path']
        return image_tag("#{@tmdb.base_url}w92#{person['profile_path']}", :height => height)
      end
    else
      if person.profile_path
        return image_tag("#{@tmdb.base_url}w92#{person.poster_path}", :height => height)
      end
    end
    image_tag '/avatars/thumb/missing.png', :height => height
  end

  def get_poster_url(movie)
    if movie.poster.sizes.w342.url[-3,3] == 'jpg'
      return movie.poster.sizes.w342.url
    end
    if movie.class == Hash
      if movie['poster_path']
        return "#{@tmdb.base_url}w500#{movie['poster_path']}"
      end
    else
      if movie.poster_path
        return "#{@tmdb.base_url}w500#{movie.poster_path}"
      end
    end
    'no_poster.jpg'
  end
  
  def get_thumb_url(movie)
    if movie.class == Hash
      if movie['poster_path']
        return "#{@tmdb.base_url}w92#{movie['poster_path']}"
      end
    else
      if movie.poster_path
        return "#{@tmdb.base_url}w92#{movie.poster_path}"
      end
    end
    'no_poster.jpg'
  end

  def tmdb_url(movie)
    "http://www.themoviedb.org/movie/" + movie.id.to_s()
  end

  def imdb_url(movie)
    "http://www.imdb.com/title/" + movie.imdb_id
  end

end
