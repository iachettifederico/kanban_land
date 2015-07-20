require "json"

require "./plugins/extension_matchers"
require "./plugins/haml_helpers"

require "forme"

Dir['./models/*.rb'].each{|f| require f}

class KanbanLand < Roda
  plugin :render, engine: "haml"
  plugin :json, classes: [Array, Hash, Board]
  plugin :path_matchers
  plugin :empty_root

  plugin :h

  plugin :extension_matcher
  plugin :haml_helpers
  
  
  route do |r|
    r.on "boards" do
      @board_repo = RedisBoards.new

      r.root do
        view "/boards/all", locals: {boards: @board_repo.all}
      end

      r.is "new" do
        view("boards/form", locals: {board: @board_repo.new})
      end
      
      r.post do
        @board_repo.create(name: r['name'], slug: r['slug'])
        r.redirect "/boards"
      end

      r.on ":slug" do |slug|
        @board = @board_repo.find(slug)
        r.root do
          view "boards/board", locals: {board: @board}
        end
      end
    end

    r.on "api" do
      r.on "boards" do
        @board_repo = RedisBoards.new


        r.post do
          @board_repo.create(name: r['name'], slug: r['slug'])
          r.redirect "/api/boards/all.json"
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
