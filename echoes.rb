# frozen_string_literal: true

require 'rest-client'
require 'dotenv/load'
require 'base64'
require 'json'
require 'base64'

base64id = Base64.strict_encode64("#{ENV['ClIENT_ID']}:#{ENV['ClIENT_SECRET']}")

r = RestClient.post('https://accounts.spotify.com/api/token',
                    { grant_type: :client_credentials },
                    Authorization: "Basic #{base64id}")

access_token = JSON.parse(r.body, symbolize_names: true)[:access_token]

puts 'Input Genre or Mood!'
search_word = gets.chomp
r = RestClient.get('https://api.spotify.com/v1/search',
                   Authorization: "Bearer #{access_token}",
                   params: { q: search_word, type: :playlist })

JSON.parse(r.body, symbolize_names: true)[:playlists][:items].each do |playlist|
  puts playlist[:href]
end
