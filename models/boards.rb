require_relative "./board"
class RedisBoards
  def initialize(source: Board)
    @source = source
  end

  def new(*args)
    @source.new(*args)
  end
  
  def all
    @source.all.to_a
  end

  def find(slug)
    @source.find(slug: slug).first
  end

  def create(attrs)
    name = attrs.fetch(:name)
    slug = attrs[:slug] || name.downcase.gsub(/\W+/, "_")
    @source.create(attrs.merge({slug: slug}))
  rescue Ohm::UniqueIndexViolation => ex
    slug_ending_number = slug.match(/_(\d+)\Z/)
    if slug_ending_number
      slug = slug.sub(/_#{slug_ending_number[1]}\Z/, "_#{slug_ending_number[1].to_i + 1}" )
    else
      slug = slug + "_1"
    end
    attrs[:slug] = slug
    create(attrs)
  end

  def destroy_all
    
  end
end
