class Passage < ActiveRecord::Base
	belongs_to :source, :class_name => 'Location', :foreign_key => 'source_id'
	belongs_to :destination, :class_name => 'Location', :foreign_key => 'destination_id'
end
