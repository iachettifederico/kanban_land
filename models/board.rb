require "ohm"
require 'ohm/contrib'

class Board < Ohm::Model
  attribute :name
  
  attribute :slug
  unique :slug
  index :slug
  
  def to_s
    name
  end

  def to_h
    {
     name: name,
     slug: slug,
    }
  end
end
