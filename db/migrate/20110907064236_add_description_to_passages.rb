class AddDescriptionToPassages < ActiveRecord::Migration
  def self.up
  	add_column "passages", "description", :text
  end

  def self.down
  end
end
