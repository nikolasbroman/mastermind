def check_matches(a, b)
  fully_correct = 0

  i = 0
  while i < b.length
    if b[i] == a[i]
      fully_correct += 1
      a = a[0...i] + a[i+1..-1]
      b = b[0...i] + b[i+1..-1]
    else
      i += 1
    end
  end

  half_correct = 0

  i = 0
  while i < b.length
    j = 0
    while j < a.length
      if b[i] == a[j]
        half_correct += 1
        a = a[0...j] + a[j+1..-1]
      else
        j += 1
      end
    end
    i += 1
  end

  [fully_correct, half_correct]
end

code = 4.times.map{ rand(1..6) }.join("")
guesses = 0

loop do
    puts
    guess = gets.chomp
    result = check_matches(code, guess)
    if result[0] == 4
      puts "You win!"
      break
    else
      puts "#{result[0]} correct number(s) in the correct position(s)"
      puts "#{result[1]} correct number(s) in a wrong position"
      guesses += 1
    end
    if guesses >= 12
      puts "You lose."
      break
    end
end