require 'yaml'

module Kumome
  module Config
    def self.config
      @config
    end

    def self.parse_argv(argv)
      default_config_path = File.expand_path('./default.yml', File.dirname(__FILE__))
      config_option = argv.find do |arg|
        arg =~ /\A(--config=?|-c=?).*\z/
      end
      if config_option
        if config_option =~ /=/
          config_path = config_option.gsub(/\A(--config=?|-c=?)/, '')
        else
          config_path = argv[argv.index(config_option) + 1]
        end
      end
      config_path = default_config_path if config_path.nil?
      config_path
    end

    def self.load
      @config = YAML.load_file(parse_argv(ARGV))
      @config
    end
  end
end
