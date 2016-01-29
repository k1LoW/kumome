class Thor
  class << self
    protected

    def banner(command, _namespace = nil, subcommand = false)
      if command.name == 'stat'
        'kumome    # OR: `kumome stat`'
      else
        # rubocop:disable Style/GlobalVars
        "#{basename} #{command.formatted_usage(self, $thor_runner, subcommand)}"
        # rubocop:enable Style/GlobalVars
      end
    end
  end
end
