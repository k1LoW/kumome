module Kumome
  module Option
    def self.options
      @options
    end

    def self.load(options)
      @options = options
    end
  end
end
