class Location < ActiveRecord::Base
	has_many :exits, :class_name => 'Passage', :foreign_key => 'source_id'
end
