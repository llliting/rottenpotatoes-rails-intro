class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_rating

    @sort_by = params[:sort_by]||session[:sort_by]||''
    session[:ratings] = @ratings_to_show
    session[:sort_by] = @sort_by

    if !params[:ratings].nil?
	@movies = Movie.with_ratings(params[:ratings].keys).order(@sort_by)
	@ratings_to_show = params[:ratings]
    elsif !session[:ratings].nil?
      	@movies = Movie.with_ratings(session[:ratings]).order(@sort_by)
      	@ratings_to_show = session[:ratings]
    else
	@movies = Movie.all.order(@sort_by)	    
       	@ratings_to_show = Hash[@all_ratings.collect { |i| [i, "1"] }]
    end
    

	#redirect_to movies_path(:ratings => @ratings_to_show, :sort_by => @sort_by)
	

    

    if @sort_by == 'release_date'
      @date_style = 'bg-warning hilite'
    end
    if @sort_by == 'title'
      @title_style = 'bg-warning hilite'
    end
    

    

    
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
