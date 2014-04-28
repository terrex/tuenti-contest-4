#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

STDIN.readline
STDIN.each_line do |line|
  pair = line.split(/\s+/).map!{ |n| n.to_i }
  puts Math.sqrt(pair[0] * pair[0] + pair[1] * pair[1]).round(2)
end
