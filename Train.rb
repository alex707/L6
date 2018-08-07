class Train

  include InstanceCounter
  include Company

  attr_reader :route, :speed, :number, :type

  @@all = {}

  TRAIN_NUMBER = /^([a-z]{3}|\d{3})(-{1}[a-z]{2}|-{1}\d{2}|[a-z]{3}|\d{3})$/i

  def initialize(number, type)
    @number     = number
    @type       = type

    @speed      = 0

    @st_number  = nil
    @route      = nil
    @cars       = []
    @@all[number] = self

    validate!
    register_instance
  end

  def validate!
    raise 'Number can\'t be nil' if number.nil?
    raise 'Number should be at least 3' if number.length < 3
    raise 'Train number has bad format' if number !~ TRAIN_NUMBER
    raise 'Type should be pass or cargo' if type != 'cargo' && type != 'pass'
    true
  end

  def valid?
    validate!
  rescue
    false
  end

  def accelerate
    @speed += 5
  end

  def breake
    @speed = 0
  end

  def route=(route)
    @route = route

    @st_number = 0
    station.take_train self
  end

  def go_to_next_st
    if @st_number != @route.stations.size - 1
      station.kick_train self
      @st_number += 1
      station.take_train self
    end
  end

  def go_to_prev_st
    if @st_number != 0
      station.kick_train self
      @st_number -= 1
      station.take_train self
    end
  end

  def prev_st
    @route.stations[@st_number - 1]
  end

  def station
    @route.stations[@st_number]
  end

  def next_st
    @route.stations[@st_number + 1]
  end

  def cars_count
    @cars.size
  end

  def car_disconnect
    @cars.delete_at(-1).status = false
  end 

  def find(number)
    @@all[number]
  end
end

