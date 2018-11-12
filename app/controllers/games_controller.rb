require 'open-uri'

class GamesController < ApplicationController
  VOYELS = [ "A", "E", "I", "O", "U" ]

  def new
    @letters = Array.new(5) { VOYELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOYELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params["letters"].split
    @word = (params["word"] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
