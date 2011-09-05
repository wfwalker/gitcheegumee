class Player < ActiveRecord::Base
	belongs_to :location
	has_many :items
end
