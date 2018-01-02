require_relative './classical'
require_relative './neo'

def runTetris
  Tetris.new 
  mainLoop
end

def runNeoTetris
  NeoTetris.new
  mainLoop
end

if ARGV.count == 0
  runNeoTetris
elsif ARGV.count != 1
  puts "usage: Tetris-V.rb [neo | classical]"
elsif ARGV[0] == "neo"
  runNeoTetris
elsif ARGV[0] == "classical"
  runTetris
else
  puts "usage: Tetris-V.rb [neo | classical]"
end

