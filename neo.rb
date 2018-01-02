# coding: utf-8
class NeoPiece < Piece

  All_My_Pieces = All_Pieces + [rotations([[0, -1], [0, 0], [0, 1], [1, -1], [1, 0]]), # Size 5, II.
                                rotations([[0, -1], [0, 0], [0, 1], [1, 1], [1, 0]]), # Size 5, II'
                                rotations([[0, -1], [0, 0], [0, 1], [1, -1], [1, -1]]), # Size 5, I_I
                                rotations([[0, -1], [0, -2], [0, 0], [-1, 0], [-1, 1]]), # Size 5, Z
                                rotations([[0, -2], [0, -1], [0, 0], [1, 1], [1, 0]]), # Size 5, S
                                [[[0,0], [0,1],[0,-1],[1,0],[-1,0]]], # Size 5, 十
                                rotations([[0, 0], [0, 1], [1, 0]]),  # Size 3, L
                                [[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]], [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]], # Size 5 Long
                                [[[-1, 0], [0, 0], [1, 0]], [[0, -1], [0, 0], [0, 1]]], # Size 3, Long
                                rotations([[0, -1], [0, -2], [0, 0], [0, 1], [-1, 1]]), # Size 5, inverse L
                                rotations([[0, -1], [0, -2], [0, 0], [0, 1], [1, 1]]), # Size 5, L
                                rotations([[0, -1], [1, 0], [0, 0], [0, 1], [-1, 1]]), # Size 5, Strange
                                rotations([[0, -1], [1, 0], [0, 0], [0, 1], [-1, -1]]), # Size 5, inverse Strange
                                rotations([[0, -1], [0, -2], [0, 0], [0, 1], [1, 0]]),
                                rotations([[0, -1], [0, -2], [0, 0], [0, 1], [1, -1]]),
                                rotations([[0, 0], [0, 1], [-1, -1], [-1, 0], [1, 1]]),
                                [[[1, 0], [1, 1], [0, 0], [-1, -1], [-1, 0]],
                                 [[0, 0], [0, -1], [0, 1], [1, -1], [-1, 1]]],
                                [[[1, 0], [1, -1], [0, 0], [-1, 1], [-1, 0]],
                                 [[0, 0], [0, -1], [0, 1], [1, 1], [-1, -1]]],
                                rotations([[0, -1], [0, 1], [0, 0], [1, 0], [2, 0]]),
                                rotations([[0, -1], [0, -2], [0, 0], [1, 0], [2, 0]]),
                                rotations([[0, -1], [0, 1], [0, 0], [1, 1], [1, -1]])]                             

  def self.next_piece (board)
    NeoPiece.new(All_My_Pieces.sample, board)
  end
  
end

class NeoBoard < Board

  def initialize(game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = NeoPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 700
    @cheating = false
    @cheating_two = false
  end

  # Set cheating to true
  def cheat
    if @score >= 60 and !@cheating and !@cheating_two
      @cheating = true
      @score -= 60
    end
  end

  def cheat_two
    if @score >= 40 and !@cheating_two and !@cheating
      @cheating_two = true
      @score -= 40
    end
  end
  
  # Cheat if cheating is true
  def next_piece
    if @cheating
      @current_block = NeoPiece.new([[[0,0]]], self)
      @cheating = false
    elsif @cheating_two
      @current_block= NeoPiece.new([[[0,0],[0,1]],[[0,0],[1,0]]], self)
      @cheating_two = false
    else
      @current_block = NeoPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # Flip the piece
  def flip
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end
  
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..@current_block.current_rotation.size-1).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
  
end

class NeoTetris < Tetris

  def initialize
    super(true)
    neo_key_bindings
    neo_buttons
  end

  # New keybindings for flip and cheat
  def neo_key_bindings
    @root.bind('u', proc {@board.flip})
    @root.bind('k', proc {@board.cheat})
    @root.bind('j', proc {@board.cheat_two})
  end

  def neo_buttons
    cheat = TetrisButton.new('SIZE ONE PIECE (K)', 'lightgreen'){@board.cheat}
    cheat.place(35, 150, 45, 670)
    cheat_two = TetrisButton.new('SIZE TWO PIECE (J)', 'lightgreen'){@board.cheat_two}
    cheat_two.place(35, 150, 305, 670)
  end
  

  def set_board
    @canvas = TetrisCanvas.new
    @board = NeoBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows+3,
                  @board.block_size * @board.num_columns+6,
                 135, 100, @board.block_size)
    @board.draw
  end
    
end
