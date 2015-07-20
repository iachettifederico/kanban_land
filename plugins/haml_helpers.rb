class Roda
  module RodaPlugins
    module HamlHelpers
      module InstanceMethods
        def link(text=nil, href, **options, &block)
          text  = capture_haml(&block) if block_given?
          content_tag(:a, text, href: href, **options)
        end

        def page_title(text=nil, &block)
          content_tag(:div, text, class: "panel text-center", &block)
        end
        private

        def content_tag(tag, text=nil, **options, &block)
          text=capture_haml(&block) if block_given?
          html_options = options.map {|k, v| "#{k}=\"#{v}\""}.join(" ")
          "<#{tag} #{html_options}> #{text} </#{tag}>"
        end
      end
    end

    register_plugin(:haml_helpers, HamlHelpers)
  end
end
