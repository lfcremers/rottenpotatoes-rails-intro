class Movie < ActiveRecord::Base
  @all_ratings = ['G','PG','PG-13','R']
  
  def self.with_ratings(column, ratings_list)
    puts 'entering with_ratings in Movie class'

    if not column and not ratings_list
      puts 'the with_ratings input is nil'
      
      return self.all_ratings
    elsif column and not ratings_list
      return Movie.order(column)
    elsif not column and ratings_list
      return Movie.where({rating: ratings_list})
    else 
      return Movie.where({rating: ratings_list}).order(column)
    end
  end

  def self.all_ratings #static methods have to start with self.
    return @all_ratings 
  end
  
end
