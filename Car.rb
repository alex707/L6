class Car
  include Company

  attr_accessor :status

  def initialize
    @status = true

    validate!
  end

  def validate!
    raise 'Status must be true or false (used/unused)' unless !!status == status
    true
  end

  def valid?
    validate!
  rescue
    false
  end
end

