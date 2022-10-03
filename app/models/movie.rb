class Movie < ActiveRecord::Base
	def self.all_rating
		['G', 'PG', 'PG-13', 'R']
	end

	def self.with_ratings(ratings_list)
		if ratings_list.nil? 
			where(rating: ratings_list) 
		else
			all
		end
	end


end
