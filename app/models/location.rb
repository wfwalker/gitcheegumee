class Location < ActiveRecord::Base
	has_many :exits, :class_name => 'Passage', :foreign_key => 'source_id'
	has_many :entrances, :class_name => 'Passage', :foreign_key => 'destination_id'
	has_many :players
	has_many :items
	has_many :happenings do
		def recent
			Happening.recent(self)
		end
	end
end
