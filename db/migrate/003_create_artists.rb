class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :musicBrainzID
      t.string :name
      t.string :country
      t.date :dateBorn
      t.date :dateDied
      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
