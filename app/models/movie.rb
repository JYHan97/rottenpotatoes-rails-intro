class Movie < ActiveRecord::Base
    def self.all_ratings
      	all_ratings = []
      	self.select(:rating).uniq.each do |movie|
      		all_ratings << movie.rating
      	end
  	    return all_ratings
  end
end
