require 'rest-client'
require 'base64'
require 'json'
require_relative 'spotify_track'

class SpotifyClient
  attr_reader :access_token


  def initialize
    client_id = ENV['SPOTIFY_ClIENT_ID']
    client_secret = ENV['SPOTIFY_ClIENT_SECRET']
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

  class Array
    def deconstruct
      self
    end
  end

  def get_high_popularity_tracks(playlists)
    playlists.each_with_object([]) do |playlist, result_tracks|
      tracks = get_tracks_from_playlist(playlist)
      tracks.each do |track|
        case track
        in { track:  { album: { images: [_, { height: 300, url: image_url, width: 300 }, _] }, name: name, popularity: 80..100 => popularity } }
          result_tracks << SpotifyTrack.new(name, popularity, image_url)
        else
          next
        end
      end
    end
  end

  private

  def get_tracks_from_playlist(playlist)
    response = RestClient.get(playlist[:href], Authorization: "Bearer #{@access_token}")

    JSON.parse(response.body, symbolize_names: true)[:tracks][:items]
  end
end
