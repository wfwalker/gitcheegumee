class CreateHappenings < ActiveRecord::Migration
  def self.up
    create_table :happenings do |t|
      t.text :description
      t.integer :location_id
      t.integer :player_id
      t.integer :item_id
      t.integer :passage_id

      t.timestamps
    end
  end

  def self.down
    drop_table :happenings
  end
end
