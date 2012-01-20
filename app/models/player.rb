class Player < ActiveRecord::Base
	def Player.recently_updated
		Player.find(:all, :conditions => ['updated_at >= ?', Time.now - 30.minute])
	end

	belongs_to :location
	has_many :items
	has_many :happenings do
		def latest
			Happening.latest(self)
		end
	end
  	
	validates_presence_of :name, :email, :location_id
	validates_uniqueness_of :name, :email
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  	
end
