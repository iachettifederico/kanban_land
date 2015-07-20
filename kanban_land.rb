require "json"

require "./plugins/extension_matchers"

Dir['./models/*.rb'].each{|f| require f}

class KanbanLand < Roda
  plugin :render, engine: "haml"
  plugin :json, classes: [Array, Hash, Board]
  plugin :path_matchers

  plugin :extension_matcher


  route do |r|
    r.on "api" do
      r.on "boards" do
        @board_repo = RedisBoards.new

        r.post do
          @board_repo.create(name: r['name'], slug: r['slug'])
        end

        r.extension("json") do
          r.is "all" do
            @board_repo.all.map(&:to_h)
          end

          r.is ":slug" do |slug|
            @board_repo.find(slug).to_h
          end

        end
      end
    end
  end
end
