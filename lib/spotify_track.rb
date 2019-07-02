class SpotifyTrack
  attr_accessor :name, :popularity, :image_url

  def initialize(name, popularity, image_url)
    @name = name
    @popularity = popularity
    @image_url = image_url
  end

  def deconstruct_keys(keys)
    { name: name, popularity: popularity }
  end

  def popularity_comment
    case self
    in name: name, popularity: (90..100)
      "#{name} は内部スコア90点以上　すごい！！"
    in name: name, popularity: (80..89)
      "#{name} は内部スコア80点以上　すごい！！"
    end
  end
end