module Kumome
  module Option
    def self.options
      @options
    end

    def self.load(options)
      @options = options
    end

    def self.selected_resource_options?
      no_resource_options = %w(profile config period)
      !(@options.keys - no_resource_options).empty?
    end
  end
end
