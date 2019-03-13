require 'dotenv/load'
require 'bundler'
require 'themoviedb'
Bundler.require

require_relative 'models/model.rb'



class ApplicationController < Sinatra::Base

  get '/' do
    erb :index
  end
  
  post '/result' do
       
    @movie = Movie.new(params[:input1])
    @movie.get_movie_detail_by_name
    @movie.extract_n_fill
    @movie.get_backdrop_links
    @movie.backdrop_links
    @movie.get_poster_links
    @movie.poster_links
    @movie.get_trailer_links
    @movie.trailer_links
    
    
    
    
    erb :result
  end
  
end
