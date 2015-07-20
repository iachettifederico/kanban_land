class Roda
  module RodaPlugins
    module ExtensionMatchers
      module RequestMethods
        def extension(ext, preserve_extension: false)
          if remaining_path.end_with?(".#{ext}")
            @remaining_path = @remaining_path.chomp(".#{ext}") unless preserve_extension
            yield(ext)
          end
        end
      end
    end

    register_plugin(:extension_matcher, ExtensionMatchers)
  end
end
