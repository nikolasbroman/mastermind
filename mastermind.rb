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
    #todo: ask for new game
  end

  def choose_role
    puts "Choose a role:"
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
    puts "Choose difficulty level:"
    puts "1) Easy"
    puts "2) Normal"
    while input = gets.chomp.downcase
      case input
      when "1", "1) easy", "easy"
        return "easy"
      when "2", "2) normal", "normal"
        return "normal"
      else
        puts "Sorry, I couldn't understand you. Please try again:"
      end
    end
  end

  def create_board
    @board = Board.new(@maker.get_code)
  end

  def begin_guessing
    12.times do
      guess = @breaker.get_guess
      matches = @board.check_matches(guess)
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
  end

  def show_breaker_victory
    #todo: change message based on whether Human is maker or breaker.
    puts "Secret code is broken! Congratulations!"
  end

  def show_breaker_defeat
    #todo: change message based on whether Human is maker or breaker.
    puts "Unable to break secret code. Game over."
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

  #todo: get code

  def get_guess
    while guess = gets.chomp
      if guess =~ /^[1-6][1-6][1-6][1-6]$/
        return guess
      else
        puts "Invalid guess. Please enter a 4 digits with each digit in the range 1–6."
      end
    end
  end

end


class Computer

  def set_difficulty(difficulty)
    @difficulty = difficulty
  end

  def get_code
    4.times.map{ rand(1..6) }.join("")
  end

  #todo: get guess (depending on difficulty level)

end


#if Humans & Computers end up having same methods
#then create "class Player" that they can inherit from


mastermind = Mastermind.new
mastermind.new_game