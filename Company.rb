module Company
  attr_accessor :company_name

  def initialize company_name
    @company_name = company_name

    validate!
  end

  def validate!
    raise 'Company name shuold be not nil' if company_name.nil?
    raise 'Company name length should be at least 1' if company_name.length < 1
    true
  end

  def valid?
    validate!
  rescue
    false
  end
end

