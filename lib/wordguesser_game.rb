class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil?
      raise ArgumentError
    end

    if letter.empty? || letter !~ /\A[a-zA-Z]\z/
      raise ArgumentError
    end

    letter = letter.downcase
    if @guesses.include?(letter)
      return false 
    end
     
    if @wrong_guesses.include?(letter)
      return false 
    end

    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    return true
  end

  def word_with_guesses
    result = ''
    @word.each_char do |char|
      if @guesses.include?(char)
        result += char
      else
        result += '-'
      end
    end
    result
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7 
      return :lose
    end

    if !word_with_guesses.include?('-')
      return :win 
    end
    return :play
  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
