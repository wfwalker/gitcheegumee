class CreatePassages < ActiveRecord::Migration
  def self.up
    create_table :passages do |t|
      t.string :title
      t.integer :source_id
      t.integer :destination_id

      t.timestamps
    end
  end

  def self.down
    drop_table :passages
  end
end
