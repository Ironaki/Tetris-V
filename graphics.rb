require 'tk'

class TetrisRoot
  def initialize(neo = false)
    if neo
    @root = TkRoot.new('height' => 720, 'width' => 500, 
                       'background' => 'azure') {title "Tetris-V -- Neo"}
    else
    @root = TkRoot.new('height' => 720, 'width' => 500, 
                       'background' => 'azure') {title "Tetris-V -- Classical"}
    end
  end

  def bind(char, callback)
    @root.bind(char, callback)
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :root
end

class TetrisTimer
  def initialize
    @timer = TkTimer.new
  end

  def stop
    @timer.stop
  end

  def start(delay, callback)
    @timer.start(delay, callback)
  end
end

class TetrisCanvas
  def initialize
    @canvas = TkCanvas.new('background' => 'cornsilk')
  end

  
  def place(height, width, x, y, block_size)
    @canvas.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
    draw_grid(height, width, block_size)
  end

  def draw_grid(height, width, block_size)
    (1..height/block_size-1).each{|r| TkcLine.new(@canvas, 0, 20*r, width, 20*r, :fill=>'grey60')}
    (1..width/block_size-1).each{|r| TkcLine.new(@canvas, 20*r+3, 0, 20*r+3, height, :fill=>'grey60')}
  end

  def unplace
    @canvas.unplace
  end

  def delete
    @canvas.delete
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :canvas
end

class TetrisLabel
  def initialize(wrapped_root, &options)
    unwrapped_root = wrapped_root.root
    @label = TkLabel.new(unwrapped_root, &options)
  end

  def place(height, width, x, y)
    @label.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end

  def text(str)
    @label.text(str)
  end
end

class TetrisButton
  def initialize(label, color)
    @button = TkButton.new do 
      text label
      background color
      command (proc {yield})
    end
  end

  def place(height, width, x, y)
    @button.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end
end

class TetrisRect
  def initialize(wrapped_canvas, a, b, c, d, color)
    unwrapped_canvas = wrapped_canvas.canvas
    @rect = TkcRectangle.new(unwrapped_canvas, a, b, c, d, 
                             'outline' => 'black', 'fill' => color)
  end

  def remove
    @rect.remove
  end

  def move(dx, dy)
    @rect.move(dx, dy)
  end

end

def mainLoop
  Tk.mainloop
end

def exitProgram
  Tk.exit
end
