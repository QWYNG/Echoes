require 'dotenv/load'
require "awesome_print"
require './spotify_client'

spotify_client = SpotifyClient.new(ENV['ClIENT_ID'], ENV['ClIENT_SECRET'])

puts 'Input Genre or Mood!'
search_word = gets.chomp

puts 'searching now…'

playlists = spotify_client.search_playlist(search_word)

result = spotify_client.get_high_popularity_tracks(playlists)

pp result
