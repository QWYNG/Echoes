# frozen_string_literal: true

require 'natto'

class NattoRanker
  attr_reader :ranking
  def initialize(string)
    analysed_strings = analysis_with_mecab(string)
    @ranking = rank(analysed_strings)
  end

  private

  def analysis_with_mecab(string)
    analysed_strings = []
    Natto::MeCab.new('-F%f[0],%f[1]').parse(string) do |n|
      type = n.feature.split(',').first
      sub_type = n.feature.split(',')[1]
      next unless %w[名詞 形容詞].include? type # 名詞か形容詞を取り出す
      next unless n.surface != 'of' # of がなぜか一般名詞なので削る
      next if %w[サ変接続 数].include? sub_type # 数とサ変接続は除く

      analysed_strings << n.surface
    end

    analysed_strings
  end

  def rank(strings)
    strings.tally.sort { |a, b| b[1] <=> a[1] }
  end
end