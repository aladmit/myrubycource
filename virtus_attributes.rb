require 'virtus'

class Duration < Virtus::Attribute
  def coerce(value)
    value.to_i
  end
end

class StrArray < Virtus::Attribute
  def coerce(value)
    value.split(',')
  end
end
