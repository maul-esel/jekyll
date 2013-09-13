module Jekyll
  class PluginManager
    def self.load(site)
      @site = site
      unless @site.safe
        require_files
        collect_plugins
      end
    end

    # Get the implementation class for the given Converter.
    #
    # klass - The Class of the Converter to fetch.
    #
    # Returns the Converter instance implementing the given Converter.
    def self.getConverterImpl(klass)
      matches = self.converters.select { |c| c.class == klass }
      if impl = matches.first
        impl
      else
        raise "Converter implementation not found for #{klass}"
      end
    end

    def self.collect_plugins
      @converters = instantiate_subclasses(Jekyll::Converter)
      @generators = instantiate_subclasses(Jekyll::Generator)
    end

    def self.converters
      @converters
    end

    def self.generators
      @generators
    end

    def self.require_files
      plugins_path.each do |path|
        Dir[File.join(path, "**/*.rb")].each do |file|
          require file
        end
      end
    end

    # Internal: Setup the plugin search path
    #
    # Returns an Array of plugin search paths
    def self.plugins_path
      if (config['plugins'] == Jekyll::Configuration::DEFAULTS['plugins'])
        [File.join(@site.source, config['plugins'])]
      else
        Array(config['plugins']).map { |d| File.expand_path(d) }
      end
    end

    # Create array of instances of the subclasses of the class or module
    #   passed in as argument.
    #
    # klass - class or module containing the subclasses which should be
    #         instantiated
    #
    # Returns array of instances of subclasses of parameter
    def self.instantiate_subclasses(klass)
      klass.subclasses.select do |c|
        !@site.safe || c.safe
      end.sort.map do |c|
        c.new(config)
      end
    end

    def self.config
      @site.config
    end
  end
end