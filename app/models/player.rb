class Player < ActiveRecord::Base
	belongs_to :location
	has_many :items

	validates_presence_of :name, :email
	validates_uniqueness_of :name, :email
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  	
end
