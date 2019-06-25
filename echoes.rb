require 'dotenv/load'
require_relative 'spotify_client'
require_relative 'youtube_likes_videos_getter'
require_relative 'natto_ranker'


class Echoes
  class << self
    def run
      puts 'Getting your Youtube likes...'

      likes_videos_getter = YoutubeLikesVideosGetter.new
      likes_videos_getter.get_likes_list!

      natto_ranker = NattoRanker.new(likes_videos_getter.titles)

      spotify_client = SpotifyClient.new(ENV['ClIENT_ID'], ENV['ClIENT_SECRET'])

      puts "search spotify with #{natto_ranker.ranking.first[0]}"
      playlists = spotify_client.search_playlist(natto_ranker.ranking.first[0])
      result = spotify_client.get_high_popularity_tracks(playlists)

      pp result
    end
  end
end

Echoes.run