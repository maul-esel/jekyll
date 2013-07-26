module Jekyll
  class PathHelper

    def self.add_leading_slash!(path)
      path.sub!(/\A([^\/])/, '/\1') || path
    end

    def self.add_leading_slash(path)
      self.add_leading_slash!(path.dup)
    end

    def self.add_trailing_slash!(path)
      path.sub!(/([^\/])\z/, '\1/') || path
    end

    def self.add_trailing_slash(path)
      self.add_trailing_slash!(path.dup)
    end

    def self.remove_leading_slash(path)
      path.sub(/\A\//, '')
    end

    def self.remove_trailing_slash(path)
      path.sub(/\/\z/, '')
    end

    def self.has_leading_slash?(path)
      path.start_with? '/'
    end

    def self.has_trailing_slash?(path)
      path.end_with? '/'
    end
  end
end