require 'uri'
require 'net/http'
require 'json'
require 'themoviedb' #ruby wrapper for TMDB
require 'pp'
require 'dotenv/load'

Tmdb::Api.key(ENV["API_KEY"])

class Movie #the movie class
    
    attr_reader :movie_ID, :movie_backdrop, :movie_description, :movie_poster, :movie_name, :movie_poster, :movie_rating, :movie_title, :movie_release, :poster_links, :trailer_links, :backdrop_links, :the_hash
    
    def initialize(movie_name, keyword_movie)#when used for Movie, only the movie_name parameter is used. When used for Keyword, only the Keyword_movie parameter is used.
       @movie_name = movie_name 
       @keyword_movie = keyword_movie
       @movie_ID = []   #bunch of arrays and a hash to store data
       @movie_backdrop = []
       @movie_poster = []
       @movie_rating = []
       @movie_title = []
       @movie_description = []
       @movie_release = []
       @poster_links = []
       @trailer_links = []
       @backdrop_links = []
       @the_hash = {}
    end
    
    def get_movie_detail_by_ID
        #used when only one movie is wanted. The ID of the movie is needed though
         
         movie = Tmdb::Movie.detail(@keyword_movie)

       
          movie.each do |key, value| #this function pulls out the necessary info that will be used in other function or show up in the View 
             if key == "title"
                @movie_title << value
                # puts value
                # puts key
             end
             if key == "id"
                @movie_ID << value 
                # puts value
             end
             if key == "vote_average"
                @movie_rating << value 
                # puts value
             end
             if key == "poster_path"
                @movie_poster << value 
                # puts value
             end
             if key == "overview"
                @movie_description << value
                # puts value
             end
             if key == "release_date"
                @movie_release << value
                # puts value
             end
          end
    end

def get_movie_detail_by_name
   @search = Tmdb::Search.new
    @search.resource('movie') # determines type of resource  movie/person/keyword
    @search.query(@movie_name) # the query to search against
    return @search.fetch # makes request
    # return @search.fetch
    
end


    def extract_n_fill  #this function pulls out the necessary info that will be used in other function or show up in the View 
         movies = @search.fetch

       movies.each do |x|
          x.each do |key, value|
             if key == "title"
                @movie_title << value
                # puts value
                # puts key
             end
             if key == "id"
                @movie_ID << value 
                # puts value
             end
             if key == "vote_average"
                @movie_rating << value 
                # puts value
             end
             if key == "poster_path"
                @movie_poster << value 
                # puts value
             end
             if key == "overview"
                @movie_description << value
                # puts value
             end
             if key == "release_date"
                @movie_release << value
                # puts value
             end
          end
          
       end
    
    
    # return @movie_title.length, @movie_rating.length, @movie_poster.length, @movie_description.length, @movie_release.length, @movie_ID.length
    
        
    end
    
    def get_poster_links
        @movie_poster.each do |path| #
           @poster_links << "https://image.tmdb.org/t/p/original#{path}" 
        end
    end
    
    def get_trailer_links
        @movie_ID.each { |id|
        begin
        movie = Tmdb::Movie.trailers(id)
        @trailer_links << "#{movie["youtube"][0]["source"]}" #extracts trailer source 
        rescue
        @trailer_links << "Yp_LQDn0W04"
            
        end
        }
    end
    
    def get_backdrop_links
        @movie_ID.each { |id|
        begin
        movie = Tmdb::Movie.images(id)
        @backdrop_links << "https://image.tmdb.org/t/p/original#{movie['backdrops'][0]["file_path"]}" #extracts the backdrop source and concatnates it with the base url
        rescue
        @backdrop_links << "/Image_not_available.png"
            
        end
        }
    end
    
    
    
    
end

class Keyword
    
    attr_reader :requested_keyword, :related_keyword, :fetched_movie_ID, :movie_instances, :movie_instances_test
   
   def initialize(keyword)
      @keyword = keyword 
      @requested_keyword = {}
      @related_keyword = []
      @fetched_movie_ID = []
      @movie_instances = {}
      @movie_instances_test = []
   end
   
   def get_keyword_ID
        search = Tmdb::Search.new
        search.resource('keyword') # determines type of resource
        search.query(@keyword) # the query to search against
        search.fetch # makes request returns the IDs of search terms
        @keywordz = search.fetch
          
   end
   
   def separate_keywords
       keyword = @keywordz
       keyword.each do |x|
         if keyword[0]["name"] == @keyword
             @requested_keyword[keyword[0]["name"]] = keyword[0]["id"] 
         end
      end
   end
   
   def get_movie_names # returns the ID of a keyword that the user enters
    url = URI("https://api.themoviedb.org/3/keyword/#{@requested_keyword[@keyword]}/movies?include_adult=false&language=en-US&api_key=#{ENV["API_KEY"]}")
    response = Net::HTTP.get(url)
    response = JSON.parse(response)
    response["results"].each do |element|
        @fetched_movie_ID << element["id"]
    end
   end
   
   def keyword_movie_instance
       @fetched_movie_ID.each do |movie| #Movie class instance
         movie = Movie.new("fightclub",movie )
        movie.get_movie_detail_by_ID
        movie.get_backdrop_links
        movie.get_poster_links
        movie.get_trailer_links
        movie.backdrop_links
        @movie_instances[movie.movie_title.join] = [ movie.poster_links.join, movie.trailer_links.join,  movie.backdrop_links.join,  movie.movie_ID.join, movie.movie_description.join,  movie.movie_rating.join,  movie.movie_release.join]#storing the data like this makes it easier to access later.
        
       end
        #create a def and extract all the info manually and put in a hash with arrays
   end
   
#   def keyword_movie_info
#       @movie_instance_test[1].get_movie_detail_by_ID 
#     #   @movie_instance_test[1].movie_title
#   end
   
   
    
end

# titanic = Movie.new("titanic",0)
#  titanic.get_movie_detail_by_name
# titanic.extract_n_fill
# titanic.create_hash
# pp titanic.the_hash

# cop = Keyword.new("space")
# cop.get_keyword_ID
# cop.separate_keywords[0]["name"]
# cop.separate_keywords
# cop.requested_keyword
# cop.get_movie_names
 
#  cop.keyword_movie_instance
# #  puts cop.movie_instances
#  cop.movie_instances.each do |movie, detail|
#     puts detail[2]
#  end
# puts cop.movie_instances["Avengers: Infinity War"][0]
#   cop.keyword_movie_info


# cop.keyword_movie_instance
# cop.movie_instances

# for the Keyword class retrieve movie ID, not titles, cuz one ID =  one movie. Fill in the get_movie_by_ID in the Movie class




# puts  "https://www.youtube.com/watch?v=#{ Tmdb::Movie.trailers(213362)["youtube"][0]["source"]}"


# puts Tmdb::Movie.detail(550)

# movie = Movie.new("movie", 434555) 
# movie.get_movie_detail_by_ID

#  movie.get_trailer_links
#  puts movie.trailer_links
 