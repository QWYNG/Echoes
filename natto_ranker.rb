# frozen_string_literal: true

require 'natto'

class NattoRanker
  attr_reader :ranking
  def initialize(string)
    parsed_words = parse_with_mecab(string)
    @ranking = rank(parsed_words)
  end

  def first_rank_word
    ranking.first[0]
  end

  private

  def parse_with_mecab(words)
    parsed_words = []
    Natto::MeCab.new('-F%f[0],%f[1]').parse(words) do |parsed_word|
      sorted_word = sort_part_of_speech(parsed_word)
      parsed_words << sorted_word if sorted_word
    end

    parsed_words
  end

  def rank(parsed_words)
    parsed_words.tally.sort { |a, b| b[1] <=> a[1] }
  end

  def sort_part_of_speech(parsed_word)
    type = parsed_word.feature.split(',').first
    sub_type = parsed_word.feature.split(',')[1]
    return false unless %w[名詞 形容詞].include? type
    return false unless parsed_word.surface != 'of' # of がなぜか一般名詞なので削る
    return false if %w[サ変接続 数].include? sub_type

    parsed_word.surface
  end
end