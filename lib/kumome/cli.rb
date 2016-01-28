require 'thor'
require 'terminal-table/import'
require 'term/ansicolor'
include Term::ANSIColor

module Kumome
  include Term::ANSIColor

  class CLI < Thor
    class_option :profile
    class_option :period, type: :numeric, default: 300
    class_option :config, type: :string
    default_command :stat

    Kumome::Config.load

    desc 'stat', 'Show AWS resource statistics'
    Kumome::Config.config['resources'].each_key do |r|
      option r, type: :string
    end
    def stat
      Kumome::Option.load(options)
      data = Kumome::Stat.data
      out_table(data)
      # @TODO tailf stat
    end

    desc 'config', 'Out config.yml'
    def config
      puts File.read(Kumome::Config.parse_argv(ARGV))
    end

    private

    def out_table(data)
      ids = {}
      metrics_header = {}
      Kumome::Config.config['resources'].each do |resource_name, resource|
        next if options[resource_name.to_sym].nil?
        options[resource_name.to_sym].split(',').each do |id|
          ids[id] = resource['metrics'].size
          resource['metrics'].each do |name, _metric|
            key = resource_name + id + name.to_s
            metrics_header[key] = name.to_s
          end
        end
      end
      header = ['']
      ids.each do |id, colspan|
        header << { value: id, colspan: colspan, alignment: :center }
      end
      t = table(header)
      t.style = { alignment: :right, border_x: '-' }
      t << metrics_header.values.unshift(:timestamp)
      t << :separator
      data.sort_by { |k, _| k.to_i }.each do |timestamp, d|
        line = [timestamp]
        metrics_header.each_key do |h|
          if d.key?(h)
            line << d[h]
          else
            line << ''
          end
        end
        t << line
      end
      lines = t.to_s.lines
      footer = lines.pop
      lines.each do |line|
        puts line
      end
    end
  end
end
