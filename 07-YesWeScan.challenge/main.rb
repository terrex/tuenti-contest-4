#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

$one = STDIN.readline.chomp.to_i
$other = STDIN.readline.chomp.to_i

$already_looked_up = []

def lookup(one)
  if $already_looked_up.index(one)
    []
  else
    $already_looked_up << one
    #array of pairs [line number, other person]
    %x{grep -n #{one} test.log}.split(/\n/).map do |line|
      res = line.chomp.split(/[: ]/).map(&:to_i)
      if res[1] == one
        res[1] = res[2]
      end
      res.delete_at(2)
      res
    end
  end
end

def lookup_chain(one, other, indexes)
  lookup(one).each do |option|
    if option[1] == other
      indexes << option[0]
      return indexes.max
    else
      result = lookup_chain(option[1], other, indexes + [option[0]])
      if result
        return result
      end
    end
  end

  nil
end

result = lookup_chain($one, $other, [])
if result
  puts "Connected at #{result - 1}"
else
  puts "Not connected"
end
