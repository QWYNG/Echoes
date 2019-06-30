require 'dotenv/load'
require_relative 'lib/natto_ranker'
require_relative 'lib/spotify_client'
require_relative 'lib/youtube_likes_videos_getter'


class Echoes
  class << self
    def run(credentials_request)
      likes_videos_getter = YoutubeLikesVideosGetter.new(credentials_request)
      natto_ranker = NattoRanker.new(likes_videos_getter.titles)
      spotify_client = SpotifyClient.new
      playlists = spotify_client.search_playlist(natto_ranker.first_rank_word)
      spotify_client.get_high_popularity_tracks(playlists).first(10)
    end
  end
end