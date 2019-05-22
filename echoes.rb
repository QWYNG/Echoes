require 'dotenv/load'
require "awesome_print"
require './spotify_client'

spotify_client = SpotifyClient.new(ENV['ClIENT_ID'], ENV['ClIENT_SECRET'])

puts 'Input Genre or Mood!'
search_word = gets.chomp

puts 'searching now...'
playlists = spotify_client.search_playlist(search_word)

result = {}

playlists.each do |playlist|
  tracks = spotify_client.get_tracks_from_playlist(playlist)
  tracks[:items].each do |item|
    100.downto(90).each do |popularity|
      case item
      in { track:  { name: name, popularity: ^popularity } }
        result[name] = popularity
      else
        next
      end
    end
  end
end

pp result