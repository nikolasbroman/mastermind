class Object
  def before_prompt
    print "> "
  end
end

class Mastermind

  def initialize
    @maker
    @breaker
    @board
  end

  def new_game
    show_opening_message
    new_round
  end

  private

  def show_opening_message
    puts
    puts
    puts "123456123456123456123456123456123456"
    puts "12345612345              23456123456"
    puts "1234561234   Mastermind   3456123456"
    puts "12345612345              23456123456"
    puts "123456123456123456123456123456123456"
    puts "123 Programmed by Nikolas Broman 456"
    puts
    puts
    puts "============ The Rules ============="
    puts
    puts "The Code Maker makes a secret code,"
    puts "picking 4 digits from 1,2,3,4,5,6."
    puts
    puts "Examples: 1234, 6543, 5331, 4444..."
    puts
    puts "The Code Breaker tries to break the"
    puts "code in 12 guesses. After each guess"
    puts "a hint reveals how many digits are:"
    puts
    puts "- correct number & correct position"
    puts "- correct number but wrong position"
    puts
    puts "If the code is broken in 12 guesses,"
    puts "the Code Breaker wins. Otherwise the"
    puts "Code Maker wins. Have fun!"
    puts
    puts "===================================="
    puts
  end

  def new_round
    choose_role
    create_board
    begin_guessing
    ask_for_new_round
  end

  def choose_role
    puts
    puts "Choose role:"
    puts "1) Code Breaker"
    puts "2) Code Maker"
    before_prompt
    while input = gets.chomp.downcase
      puts
      case input
      when "1", "1) code breaker", "code breaker", "codebreaker", "breaker"
        @maker = Computer.new
        @breaker = Human.new
        break
      when "2", "2) code maker", "code maker", "codemaker", "maker"
        @maker = Human.new
        @breaker = Computer.new
        @breaker.set_difficulty(choose_difficulty)
        break
      else
        puts "Sorry, I couldn't understand you. Please try again."
        before_prompt
      end
    end
  end

  def choose_difficulty
    puts "Choose difficulty level:"
    puts "1) Easy"
    puts "2) Normal"
    before_prompt
    while input = gets.chomp.downcase
      case input
      when "1", "1) easy", "easy"
        difficulty = "easy"
        break
      when "2", "2) normal", "normal"
        difficulty = "normal"
        break
      else
        puts "Sorry, I couldn't understand you. Please try again."
        before_prompt
      end
    end
    puts
    difficulty
  end

  def create_board
    @board = Board.new(@maker.get_code)
    puts "The Code Maker has made a secret code."
    puts "Time to show your skills, Code Breaker!"
    puts
  end

  def begin_guessing
    12.times do |i|
      guess_number = i + 1
      guess_prompt(guess_number)
      guess = @breaker.get_guess(guess_number)
      matches = @board.check_matches(guess)
      @breaker.inform(matches) if @breaker.is_a?(Computer)
      show_correct_matches(matches)
      if matches[0] == 4
        show_breaker_victory
        return
      end
    end
    show_maker_victory
  end

  def guess_prompt(guess_number)
    case guess_number
    when 1
      puts "1st guess:"
    when 2
      puts "2nd guess:"
    when 3
      puts "3rd guess:"
    else
      puts "#{guess_number}th guess:"
    end
  end

  def show_correct_matches(matches)
    puts "= #{matches[0]} correct number(s) in the correct position(s)"
    puts "= #{matches[1]} correct number(s) in a wrong position"
    puts
  end

  def show_breaker_victory
    if @breaker.is_a?(Human)
      puts "Congratulations! You broke the secret code!"
    else
      puts "Game over. The computer broke your code."
    end
  end

  def show_maker_victory
    if @maker.is_a? Human
      puts "Congratulations! Your code is unbreakable!"
    else
      puts "Game over. You couldn't break the secret code."
    end
  end

  def ask_for_new_round
    puts
    puts "Play a new round? (yes/no)"
    before_prompt
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

  def get_code
    puts "Input a 4-digit secret code (with each digit in the range 1–6)."
    before_prompt
    while code = gets.chomp
      if code =~ /^[1-6][1-6][1-6][1-6]$/
        puts
        return code
      else
        puts "Invalid code. Please enter 4 digits with each digit in the range 1–6."
        before_prompt
      end
    end
  end

  def get_guess(guess_number)
    before_prompt
    while guess = gets.chomp
      if guess =~ /^[1-6][1-6][1-6][1-6]$/
        return guess
      else
        puts "Invalid guess. Please enter 4 digits with each digit in the range 1–6."
        before_prompt
      end
    end
  end

end


class Computer

  def initialize
    @guesses = []
    @matches = []
    @figuring_out_order = []
    @figuring_out_now = []
    @dummy_number
    @possible_combinations = []
    @final_guess = [nil, nil, nil, nil]
  end

  def set_difficulty(difficulty)
    @difficulty = difficulty
  end

  def get_code
    4.times.map{ rand(1..6) }.join("")
  end

  def get_guess(guess_number)
    if guess_number <= 6
      guess = guess_number.to_s * 4
    elsif @difficulty == "easy"
      guess = randomize_fully_correct_positions
    elsif @difficulty == "normal"
      if guess_number == 7
        randomize_figuring_out_order
        set_dummy_number
      else
        check_previous_guess_for_fully_correct_positions
      end
      guess = figure_out_fully_correct_positions
    end
    @guesses << guess
    puts "> #{guess}"
    guess
  end

  def inform(matches)
    @matches << matches
  end

  private

  def randomize_fully_correct_positions
    guess = "1111"
    while @guesses.include?(guess)
      guess = ""
      6.times { |n| guess += (n+1).to_s * @matches[n][0] }
      guess = guess.split("").shuffle.join("")
    end
    guess
  end

  def randomize_figuring_out_order 
    order = randomize_fully_correct_positions.split("")
    order_with_number_of_occurrences = []
    digits_checked = []
    order.each do |digit|
      unless digits_checked.include?(digit)
        order_with_number_of_occurrences << [digit, order.count(digit)]
        digits_checked << digit
      end
    end
    @figuring_out_order = order_with_number_of_occurrences
  end

  def set_dummy_number
    6.times do |n|
      digit = n + 1
      is_dummy = true
      @figuring_out_order.each do |array|
        if array[0] == (digit).to_s
          is_dummy = false
        end
      end
      if is_dummy
        @dummy_number = digit
        break
      end
    end
  end

  def set_possible_combinations
    digits = @figuring_out_order[0][0] * @figuring_out_order[0][1]
    dummies = @dummy_number.to_s * (@final_guess.count(nil) - @figuring_out_order[0][1])
    combination = (digits + dummies).split("")
    @figuring_out_now = @figuring_out_order.shift
    @possible_combinations = combination.permutation.to_a.uniq
  end

  def check_previous_guess_for_fully_correct_positions
    digit = @figuring_out_now[0]
    needed_matches = @figuring_out_now[1] + (4 - @final_guess.count(nil))
    positions = []
    @guesses[-1].split("").each_with_index do |n, i|
      if n == digit
        positions << i
      end
    end
    if @matches[-1][0] == needed_matches
      positions.each { |p| @final_guess[p] = digit }
      set_possible_combinations
    end
  end

  def figure_out_fully_correct_positions
    set_possible_combinations unless @possible_combinations.count > 0
    guess = @final_guess.map do |digit|
      digit == nil ? @possible_combinations[0].shift : digit
    end
    @possible_combinations.shift
    guess.join("")
  end

end

mastermind = Mastermind.new
mastermind.new_game