class Movie < ActiveRecord::Base
  @all_ratings = ['G','PG','PG-13','R']
  
  def self.with_ratings(ratings_list)
    puts 'entering with_ratings in Movie class'
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    # whenever this ic alled; needs to filter based on what's passed in
    #google ruby activerecord filter by a column
    #write down instance method vs class method
    if ratings_list.nil?
      puts 'the with_ratings input is nil'
      puts
      return self.all_ratings
    elsif 
      puts 'the with_ratings input is not nil'
      puts ratings_list
    end
    
    puts 'putting ActiveRecord'
    puts Movie.where()
    puts Hash

    return self.all_ratings
  end

  def self.all_ratings #static methods have to start with self.
    return @all_ratings 
  end
  
end
