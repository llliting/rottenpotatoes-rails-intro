class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_rating

    @sort_by = params[:sort_by]||session[:sort_by]||'title'
    #@ratings = params[:ratings]&.keys || session[:ratings] || Movie.all_rating
    #@rating_hash = 
    session[:sort_by] = @sort_by

    if params[:ratings].nil? && session[:ratings].nil?
      @movies = Movie.all.order(@sort_by)	    
      @ratings_to_show = Hash[Movie.all_rating.collect{|i|[i, "1"]}]
      session[:ratings] = Movie.all_rating
      redirect_to movies_path(:ratings => @rating_hash, :sort_by => 'title') and return

    elsif !params[:ratings].nil?
      @movies = Movie.with_ratings(params[:ratings].keys).order(@sort_by)
      @ratings_to_show = params[:ratings]
      session[:ratings] = params[:ratings].keys

    else #use session
      @movies = Movie.with_ratings(session[:ratings]).order(@sort_by)
      @ratings_to_show = Hash[session[:ratings].collect{|i|[i, "1"]}]
      redirect_to movies_path(:ratings => Hash[session[:ratings].collect{|i|[i, "1"]}], :sort_by => @sort_by) and return

    end
   

    #session[:ratings] = @ratings
    #session[:sort_by] = @sort_by
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
