class Happening < ActiveRecord::Base
	belongs_to :player
	belongs_to :location
	belongs_to :item
	belongs_to :passage

	def Happening.recent(happening_list)
		happening_list.select { |happening| (DateTime.now.to_i - happening.created_at.to_i) < 500 }
	end

	def Happening.latest(happening_list)
		happening_list.sort{ |x, y| y.created_at <=> x.created_at}.first
	end
end
