# frozen_string_literal: true

require 'rest-client'
require 'dotenv/load'
require 'base64'
require 'json'
require 'base64'

class SpotifyClient
  attr_reader :access_token

  def initialize(client_id, client_secret)
    base64id = Base64.strict_encode64("#{client_id}:#{client_secret}")

    r = RestClient.post('https://accounts.spotify.com/api/token',
                        { grant_type: :client_credentials },
                        Authorization: "Basic #{base64id}")

    @access_token = JSON.parse(r.body, symbolize_names: true)[:access_token]
  end

  def search_playlist(search_word)
    response = RestClient.get('https://api.spotify.com/v1/search',
                              Authorization: "Bearer #{@access_token}",
                              params: { q: search_word, type: :playlist, limit: 50 })

    JSON.parse(response.body, symbolize_names: true)[:playlists][:items]
  end
end

spotify_client = SpotifyClient.new(ENV['ClIENT_ID'], ENV['ClIENT_SECRET'])

puts 'Input Genre or Mood!'
search_word = gets.chomp

playlists = spotify_client.search_playlist(search_word)

playlists.each do |playlist|
  response = RestClient.get(playlist[:href], Authorization: "Bearer #{spotify_client.access_token}").body
  JSON.parse(response, symbolize_names: true)[:tracks][:items].each do |item|
    case item
    in { track:  { album: { name: name }, popularity: 100 } }
      puts name
    else
      next
    end
  end
end