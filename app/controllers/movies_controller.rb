class MoviesController < ApplicationController

  def show
    puts 'entering show method'
    id = params[:id] # retrieve movie ID from URI route 

    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #when you get ratings from params, it gets you the hash map;
  def index

    @ratings_to_show = Movie.all_ratings
    @all_ratings = Movie.all_ratings
    @movies = Movie.all

    @sorting = nil
    
    if params[:sorting_column]  
      @sorting = params[:sorting_column]
      session[:sorting_column] = @sorting
    elsif session[:sorting_column]
      @sorting = session[:sorting_column]
    end

    if @sorting == 'title'
      @title_header = 'hilite p-3 mb-2 bg-warning text-dark'
      puts 'assigning title_header'
      @title = 'hilite p-3 mb-2 bg-warning text-dark'
    end #sould there be an elsif statement instead?
    if @sorting == 'release_date'
      @release_date_header = 'hilite p-3 mb-2 bg-warning text-dark'
      puts 'assigning release_date_header'
      @release_date = 'hilite p-3 mb-2 bg-warning text-dark'
    end

    if session[:ratings] and not params[:ratings]
      @ratings_to_show = session[:ratings]
      params[:ratings] = session[:full_ratings]
    end

    if params[:ratings].nil?
      @ratings_to_show = @all_ratings
      
    elsif
      @ratings_to_show = params[:ratings].keys
      @movies = Movie.with_ratings(@sorting, params[:ratings].keys)
      
    end 

    session[:ratings] = @ratings_to_show
    session[:full_ratings] = params[:ratings]
    session[:sorting_column] = @sorting

    if not params[:ratings] and not params[:sorting_column]
      if session[:full_ratings] and not session[:sorting_column]
        redirect_to movies_path("ratings" => session[:full_ratings])
      elsif not session[:full_ratings] and session[:sorting_column]
        redirect_to movies_path("sorting_column" => session[:sorting_column])
      elsif session[:full_ratings] and session[:sorting_column]
        redirect_to movies_path("ratings" => session[:full_ratings], "sorting_column" => session[:sorting_column])
      end
    end

    puts 'putting params:'
    puts params  
    puts 'putting session keys:' 
    puts session.keys
    puts 'putting sorting column from session:'
    puts session[:sorting_column] 
  end

  def new
    puts 'entering new method'
    # default: render 'new' template
  end  

  def self.all_ratings
    return @all_ratings
  end

  def create
    puts 'entering create method'
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path #this redirects the url
  end

  def edit
    puts 'entering edit method'
    @movie = Movie.find params[:id]
  end

  def update
    puts 'entering update method'
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    puts 'entering destroy method'
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sorting_column)
  end
end


