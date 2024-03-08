class FrameCalculator

  # class method for calculating frames from rolls
  def self.calculate rolls
    calculator = self.new(rolls)
    calculator.calculate
  end

  # initialize calculator variables
  def initialize rolls
    @rolls = rolls
    @roll = nil

    @last_roll = nil
    @last_2_rolls = nil

    @frames = []
  end

  # loop through each roll, hang on to the 2 previous rolls, process current roll by building frames, and return roll sum of full frames
  def calculate
    @rolls.each_with_index do |roll,i|
      # validate roll
      unless (roll.is_a?(Integer) && roll.between?(0,9)) || ['X','/'].include?(roll)
        raise "Invalid roll value: '#{roll}'\nRoll must be an integer 0-9, 'X', or '/'"
      end

      @roll = roll

      # trail the last 2 rolls
      @last_roll = i > 0 && @rolls[i-1]
      @last_2_rolls = i > 1 && @rolls[i-2]

      break unless process_roll
    end

    # return sum of full frames and nil for incomplete frames
    @frames.map do |frame|
      if frame.include?(nil)
        nil
      else
        frame.sum
      end
    end
  end

  private

  # handle numbers, spares, strikes, and 10th frame bonus roll
  def process_roll
    if @frames.count == 10 && @frames[-1].length == 3
      handle_10th_frame_bonus
    elsif @roll == 'X'
      handle_strike
    elsif @roll == '/'
      handle_spare
    elsif @roll.is_a?(Integer)
      handle_normal
    end

    # signal to stop processing if last frame is complete
    (@frames.count == 10 && @frames[-1].all?) ? false : true
  end

  # called when a strike or spare in 10th frame
  def handle_10th_frame_bonus
    frame_roll_i = @frames[-1].index(nil)
    @frames[-1][frame_roll_i] = (@roll == 'X' && 10) || @roll

    if @frames[-2].length == 3 && @frames[-2][2].nil? && @frames[-1][1] == 10
      @frames[-2][2] = 10
    end

  end

  # adds strike frame to frame list and adds bonuses to previous special frames
  def handle_strike
    @frames << [10,nil,nil]

    if @last_roll == '/'
      @frames[-2][2] = 10
    elsif @last_roll == 'X'
      @frames[-2][1] = 10
    end

    if @last_2_rolls == 'X'
      @frames[-3][2] = 10
    end

  end

  # upgrades normal frame to spare frame by setting spare value and appending nil to frame, adds bonus to last strike frame
  def handle_spare
    @frames[-1][1] = 10 - @last_roll
    @frames[-1] << nil

    if @last_2_rolls == 'X'
      @frames[-2][2] = 10 - @last_roll
    end
  end

  # adds normal frame to frame list, set value of last normal frame roll, adds bonuses to previous special frames
  def handle_normal
    if @frames[-1].nil? || @frames[-1].all? || @frames[-1].length == 3
      @frames << [@roll, nil]
    else
      @frames[-1][1] = @roll
    end

    if @last_roll == '/'
      @frames[-2][2] = @roll
    elsif @last_roll == 'X'
      @frames[-2][1] = @roll
    end

    if @last_2_rolls == 'X'
      if @frames[-3].length == 3
        @frames[-3][2] = @roll
      else
        @frames[-2][2] = @roll
      end
    end

  end

end
