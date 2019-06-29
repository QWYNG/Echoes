require 'dotenv/load'
require_relative 'spotify_client'
require_relative 'youtube_likes_videos_getter'
require_relative 'natto_ranker'


class Echoes
  class << self
    def run(request)
      credentials_request = request.env['omniauth.auth']['credentials']
      likes_videos_getter = YoutubeLikesVideosGetter.new(credentials_request)
      likes_videos_getter.get_likes_list!
      natto_ranker = NattoRanker.new(likes_videos_getter.titles)
      spotify_client = SpotifyClient.new
      playlists = spotify_client.search_playlist(natto_ranker.ranking.first[0])
      spotify_client.get_high_popularity_tracks(playlists).first(10)
    end
  end
end