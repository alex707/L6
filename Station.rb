class Station
  include InstanceCounter

  attr_accessor :name
  attr_reader :trains

  @@all = []

  def initialize(name)
    @name   = name

    @trains = []
    @@all << self

    validate!
    register_instance
  end

  def validate!
    raise 'Name can not be nil' if name.nil?
    raise 'Name should be at least 1' if name.size < 1
    true
  end

  def valid?
    validate!
  rescue
    false
  end

  def take_train(train)
    @trains << train
  end

  def kick_train(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    # return all
    if type.nil?
      @trains

    # return by type
    else
      @trains.select { |train| train.type == type.to_s }
    end
  end

  def trains_count(type = nil)
    # method return number of 'cargo' or 'pass' trains
    # if type is null, then will return count of all trains on the st

    if @trains.any?
      # return all
      if type.nil?
        @trains.size

      # return by type
      else
        @trains.select { |train| train.type == type.to_s }.size
      end
    end
  end

  def send_train(number = nil)
    if @trains.any?
      if number.nil?
        @trains.first.go_to_next_st
      else
        @trains.each do |train|
          if train.number == number.to_s
            train.go_to_next_st
            break
          end
        end
      end
    end
  end

  def self.all
    @@all
  end
end

