class CreateArtistTrackJoinTable    < ActiveRecord::Migration

    def change
      create_table :artists_tracks, :id => false do |t|
        t.integer :track_id
        t.integer :artist_id

      end
    end
end