require 'rest-client'
require 'base64'
require 'json'

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

  def get_tracks_from_playlist(playlist)
    response = RestClient.get(playlist[:href], Authorization: "Bearer #{@access_token}")

    JSON.parse(response.body, symbolize_names: true)[:tracks]
  end
end
