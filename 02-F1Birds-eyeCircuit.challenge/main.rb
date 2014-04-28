#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

require 'matrix'

def reformat(canvas)
  minimal = canvas.min_by { |i| [i[1][0], i[1][1]] }
  dif = Vector[0, 0] - minimal[1]
  canvas.map! do |step|
    [step[0], step[1] + dif]
  end
  width = (canvas.max_by { |i| i[1][0] })[1][0]
  height = (canvas.max_by { |i| i[1][1] })[1][1]
  0.upto(height) do |y|
    0.upto(width) do |x|
      step = canvas.find { |i| i[1][0] == x && i[1][1] == y }
      if step
        print step[0]
      else
        print ' '
      end
    end
    print "\n"
  end
end

def line_to_map(line)
  starting = line.index('#')
  if starting > 0
    line = line[starting..-1] + line[0..(starting - 1)]
  end

  canvas = Array.new # [char, Vector[x, y]]
  current_position = Vector[0, 0] #[x, y]
  incr_position = Vector[0, 0]
  horizontal = true
  line.each_char do |char|
    if char == '#'
      canvas << [char, current_position]
      incr_position = Vector[1, 0]


    elsif char == '-'
      current_position = current_position + incr_position
      if !horizontal
        char = '|'
      end
      canvas << [char, current_position]


    elsif char == '/'
      if horizontal
        current_position = current_position + incr_position
        canvas << [char, current_position]
        if incr_position == Vector[1, 0]
          incr_position = Vector[0, -1]
        elsif incr_position == Vector[-1, 0]
          incr_position = Vector[0, 1]
        end
        horizontal = !horizontal
      else #vertical
        current_position = current_position + incr_position
        canvas << [char, current_position]
        if incr_position == Vector[0, -1]
          incr_position = Vector[1, 0]
        elsif incr_position == Vector[0, 1]
          incr_position = Vector[-1, 0]
        end
        horizontal = !horizontal
      end


    elsif char == '\\'
      if horizontal
        current_position = current_position + incr_position
        canvas << [char, current_position]
        if incr_position == Vector[1, 0]
          incr_position = Vector[0, 1]
        elsif incr_position == Vector[-1, 0]
          incr_position = Vector[0, -1]
        end
        horizontal = !horizontal
      else #vertical
        current_position = current_position + incr_position
        canvas << [char, current_position]
        if incr_position == Vector[0, -1]
          incr_position = Vector[-1, 0]
        elsif incr_position == Vector[0, 1]
          incr_position = Vector[1, 0]
        end
        horizontal = !horizontal
      end
    end
  end

  reformat(canvas)
end

line_to_map(STDIN.readline)
