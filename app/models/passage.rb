class Passage < ActiveRecord::Base
	has_and_belongs_to_many :locations
end
