class Player

  attr_reader :glass

  # params with index from server
  DATA_PARAMS = {
                  'figure'  => 0,
                  'x'       => 1,
                  'y'       => 2,
                  'glass'   => 3,
                  'next'    => 4
                }

  # rotate options
  DO_NOT_ROTATE = 0
  ROTATE_90_CLOCKWISE = 1
  ROTATE_180_CLOCKWISE = 2
  ROTATE_90_COUNTERCLOCKWISE = 3

  # possible figures
  FIGURES = {
              'O' => {}, # []
              'I' => {}, # |
              'J' => {}, # _|
              'L' => {}, # |_
              'S' => {}, # _|-
              'Z' => {}, # -|_
              'T' => {}  # _|_
    }

  def initialize
    @glass = Glass.new
    @o_count = 0
    self
  end

  # process data for each event from tetris-server
  def process_data(data)
    @figure, @x, @y, raw_glass, next_str = data_to_params(data)
    @next_figures = next_str.split('')
    @glass.update_state(raw_glass)
  end

  # This method should return string like left=0, right=0, rotate=0, drop'
  def make_step
    # print glass state
    @glass.print_glass
    moves_o = {0 => 4, 1 => 2, 2 => 0, 3 => -2, 4=> -4 }

    res = ""
    if @figure == 'O'
      res = "right=#{moves_o[@o_count]},drop"
      @o_count += 1
     @o_count = 0 if @o_count > 4
    end

    res
    # possible actions: left, right, rotate, drop
    # "left=1, right=0, rotate=0, drop"
  end

  # This method is used for processing event from tetris-server to params for client
  def data_to_params(data)
    raise 'No data to prepare params' unless data
    res = []
    DATA_PARAMS.each do |k, v|
      res << data.split('&')[v].gsub!("#{k}=", '')
    end
    res
  end
  private :data_to_params
end
