#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

STDIN.each_line do |line|
  puts line.split(/\s+/).map!{ |n| n.to_i }.reduce(:+)
end
