=begin

Build these features:

- human player can choose between codemaker / codebreaker

- computer player as Code Maker
--- no need for AI, random is enough

- computer player as Code Breaker
--- easy: guess randomly, keep only fully correct
--- normal: guess randomly, keep fully correct, include half correct
--- hard/impossible: no need

=end


class Mastermind

  def initialize
    @maker
    @breaker
    @board
  end

  def new_game
    #todo: show opening message & credits
    new_round
  end

  private

  def new_round
    choose_role
    create_board
    begin_guessing
    ask_for_new_round
  end

  def choose_role
    puts
    puts "Choose role:"
    puts "1) Code Maker"
    puts "2) Code Breaker"
    while input = gets.chomp.downcase
      case input
      when "1", "1) code maker" "code maker", "codemaker", "maker"
        @maker = Human.new
        @breaker = Computer.new
        @breaker.set_difficulty(choose_difficulty)
        break
      when "2", "2) code breaker" "code breaker", "codebreaker", "breaker"
        @maker = Computer.new
        @breaker = Human.new
        break
      else
        puts "Sorry, I couldn't understand you. Please try again:"
      end
    end
  end

  def choose_difficulty
    puts
    puts "Choose difficulty level:"
    puts "1) Easy"
    puts "2) Normal"
    while input = gets.chomp.downcase
      case input
      when "1", "1) easy", "easy"
        difficulty = "easy"
        break
      when "2", "2) normal", "normal"
        difficulty = "normal"
        break
      else
        puts "Sorry, I couldn't understand you. Please try again:"
      end
    end
    puts
    difficulty
  end

  def create_board
    @board = Board.new(@maker.get_code)
  end

  def begin_guessing
    12.times do |i|
      guess_number = i + 1
      guess = @breaker.get_guess(guess_number)
      matches = @board.check_matches(guess)
      @breaker.inform(matches) if @breaker.is_a?(Computer)
      show_correct_matches(matches)
      if matches[0] == 4
        show_breaker_victory
        return
      end
    end
    show_breaker_defeat
  end

  def show_correct_matches(matches)
    puts "#{matches[0]} correct number(s) in the correct position(s)"
    puts "#{matches[1]} correct number(s) in a wrong position"
    puts
  end

  def show_breaker_victory
    #todo: change message based on whether Human is maker or breaker.
    puts "Secret code is broken! Congratulations!"
  end

  def show_breaker_defeat
    #todo: change message based on whether Human is maker or breaker.
    puts "Unable to break secret code. Game over."
  end

  def ask_for_new_round
    print "Play a new round? (y/n): "
    while input = gets.chomp.downcase
      if input == "y" || input == "yes"
        new_round
        break
      elsif input == "n" || input == "no"
        puts
        puts "Thank you for playing."
        puts
        break
      else
        puts "Please type yes or no."
        print "Play a new round? (y/n): "
      end
    end
  end

end



class Board

  def initialize(code)
    @code = code
  end

  def check_matches(guess)
    code = @code
    fully_correct = 0
    i = 0
    while i < guess.length
      if guess[i] == code[i]
        fully_correct += 1
        code = code[0...i] + code[i+1..-1]
        guess = guess[0...i] + guess[i+1..-1]
      else
        i += 1
      end
    end
  
    half_correct = 0
    i = 0
    while i < guess.length
      j = 0
      while j < code.length
        if guess[i] == code[j]
          half_correct += 1
          code = code[0...j] + code[j+1..-1]
          break
        else
          j += 1
        end
      end
      i += 1
    end
    
    [fully_correct, half_correct]
  end

end


class Human

  #todo: add text before prompt, e.g. "Enter your secret code: "
  def get_code
    while code = gets.chomp
      if code =~ /^[1-6][1-6][1-6][1-6]$/
        return code
      else
        puts "Invalid code. Please enter 4 digits with each digit in the range 1–6."
      end
    end
  end

  #todo: add text before prompt, e.g. "3rd guess: "
  def get_guess(guess_number)
    while guess = gets.chomp
      if guess =~ /^[1-6][1-6][1-6][1-6]$/
        return guess
      else
        puts "Invalid guess. Please enter 4 digits with each digit in the range 1–6."
      end
    end
  end

end


class Computer

  def initialize
    @guesses = []
    @matches = []
  end

  def set_difficulty(difficulty)
    @difficulty = difficulty
  end

  def get_code
    random_sequence.join("")
  end

  def get_guess(guess_number)
    if @difficulty == "easy"
      if guess_number <= 6
        guess = guess_number.to_s * 4
      else
        guess = fully_correct_randomized
      end
    elsif @difficulty == "normal"
      #todo
    end
    @guesses << guess
    puts guess #todo: add text similar to Human, like "Computer's guess nr. X: "
    guess
  end

  def inform(matches)
    @matches << matches
  end

  private

  def random_sequence
    4.times.map{ rand(1..6) }
  end

  def fully_correct_randomized
    guess = ""
    6.times do |n|
      guess += (n+1).to_s * @matches[n][0]
    end
    guess.split("").shuffle.join("")
  end

end


#if Humans & Computers end up having same methods
#then create "class Player" that they can inherit from

mastermind = Mastermind.new
mastermind.new_game