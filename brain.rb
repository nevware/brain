class Brain
  require 'musicbrainz'
  brainz = MusicBrainz::Client.new(:username => 'username',
                                   :password => 'password')

# Find an artist by id, include artist relations
  brainz.artist(:mbid => '45d15468-2918-4da4-870b-d6b880504f77', :inc => 'artist-rels')
# Search for artists with the query 'Diplo'
  puts brainz.artist(:query => 'Diplo')
end