#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

def diff(a, b)
  n = 0
  0.upto(a.length - 1) do |i|
    if a[i] != b[i]
      n += 1
    end
  end
  n
end

def make_solution(initial, partial_solution, remaining)
  if diff(initial, partial_solution[0]) == 1
    [initial] + partial_solution
  else
    options = remaining.select { |i| diff(i, partial_solution[0]) == 1 }
    sols = options.map do |option|
      rem = remaining.dup
      rem.delete option
      make_solution(initial, [option] + partial_solution, rem)
    end
    sols.compact.min_by { |sol| sol.count }
  end
end

$initial = STDIN.readline.chomp
$final = STDIN.readline.chomp
$allowed = []
STDIN.each_line do |line|
  $allowed << line.chomp
end

$allowed.uniq!
$allowed.delete $initial
$allowed.delete $final

puts make_solution($initial, [$final], $allowed.dup).join('->')
