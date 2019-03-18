require 'dotenv/load'
require 'bundler'
require 'themoviedb'
require 'json'
Bundler.require

require_relative 'models/model.rb'



class ApplicationController < Sinatra::Base

  get '/' do
    erb :index
  end
  
  post '/result' do
    @hash = {}
    @type = params[:type]
    if params[:type] == "movie"
      @ui = Movie.new(params[:input1], 0)
      @ui.get_movie_detail_by_name
      @ui.extract_n_fill
      @ui.get_backdrop_links
      @ui.backdrop_links
      @ui.get_poster_links
      @ui.poster_links
      @ui.get_trailer_links
      @ui.trailer_links
      
      i = 0
      
      while i <= @ui.movie_title.length do
        @hash[@ui.movie_title[i]] = [ @ui.poster_links[i], @ui.trailer_links[i],  @ui.backdrop_links[i],  @ui.movie_ID[i], @ui.movie_description[i],  @ui.movie_rating[i],  @ui.movie_release[i]]
        i += 1
      end
       
       
         
       
    elsif params[:type] == "keyword"
      @ui2 = Keyword.new(params[:input1])
      @ui2.get_keyword_ID
      @ui2.separate_keywords[0]["name"]
      @ui2.separate_keywords
      @ui2.requested_keyword
      @ui2.get_movie_names
      @ui2.keyword_movie_instance
      @ui2.movie_instances
      
    end
    
    
    
    
    erb :result
  end
  
end
