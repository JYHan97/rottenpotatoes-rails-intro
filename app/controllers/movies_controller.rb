class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all # Initial code
    
    # Sort the list of movies by params[:order]->'title' or 'release_data'
    # @movies = Movie.order params[:order] # Part 1 code
    
    # Part 2
    
    @all_ratings = Movie.all_ratings # set @all_ratings by consulting the Modle
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    @order = params[:order] || session[:order]
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, "1"]}]
    end
    if session[:ratings] != @selected_ratings
      session[:ratings] = @selected_ratings
    end
    if session[:order] != @order
      session[:order] = @order
    end
    
    # show selected boxes' items
    @movies = Movie.with_ratings(@selected_ratings.keys)
    # keep sorted column
    @movies = @movies.order @order
    # end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilite header_name
    if header_name == params[:order]
      return 'hilite'
    else
      return nil
    end
  end
  helper_method :hilite

end
