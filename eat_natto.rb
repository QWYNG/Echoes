require_relative 'youtube_client'
require 'natto'

likes_getter = YoutubeLikesVideosGetter.new
likes_getter.get_likes_list!


nm = Natto::MeCab.new
puts nm.version
