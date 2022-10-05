class MoviesController < ApplicationController

  def show
    puts 'entering show method'
    id = params[:id] # retrieve movie ID from URI route 

    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #when you get ratings from params, it gets you the hash map;
  def index
    #what's the whole $cnt thing?

    @ratings_to_show = Movie.all_ratings
    @all_ratings = Movie.all_ratings
    @movies = Movie.all

    sorting = nil
    boxes_selected = nil

    if params[:sorting_column]
      sorting = params[:sorting_column]
      session[:sorting_column] = sorting
    end 
    if session[:sorting_column]
      sorting = session[:sorting_column]
    end
    
    if sorting == 'title'
      @title_header = 'hilite'
    elsif sorting == 'release_date'
      @release_date_header = 'hilite'
    end

    if params[:ratings].nil?
      @ratings_to_show = []
      @movies = []
    elsif
      puts 'not nil params ratings'
      @ratings_to_show = Movie.with_ratings(params[:ratings].keys)
    @movies = Movie.with_ratings(selected_boxes)
    end 

    if session[:ratings]
      @ratings_to_show = session[:ratings]
    end

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
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []  #how exactly to populate this if things get checked?
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