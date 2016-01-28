require 'awsecrets'

module Kumome
  class Stat
    OPERATORS = {
      'GreaterThanOrEqualToThreshold' => '>=',
      'GreaterThanThreshold' => '>',
      'LessThanThreshold' => '<',
      'LessThanOrEqualToThreshold' => '<='
    }

    def self.data
      options = Kumome::Option.options
      Awsecrets.load(profile: options[:profile])
      @client = Aws::CloudWatch::Client.new
      ids = {}
      metrics_header = {}
      data = {}
      Kumome::Config.config['resources'].each do |resource_name, resource|
        next if options[resource_name.to_sym].nil?
        options[resource_name.to_sym].split(',').each do |id|
          resource['metrics'].each do |name, metric|
            key = resource_name + id + name.to_s
            config = build_cw_config(resource, metric, options, id)
            output = @client.get_metric_statistics(config)
            output.datapoints.each do |point|
              data[point.timestamp] = {} unless data.key?(point.timestamp)
              data[point.timestamp][key] = colorize(point[metric['statistic'].underscore], metric['alarm'])
            end
          end
        end
      end
      data
    end

    def self.build_cw_config(resource, metric, options, id)
      config = {
        metric_name: metric['metric_name'],
        namespace: resource['namespace'],
        statistics: [metric['statistic']],
        dimensions: [{ name: resource['dimensions_name'], value: id }],
        start_time: (Time.now - 3600).iso8601,
        end_time: Time.now.iso8601,
        period: options[:period]
      }
      config[:unit] = metric['unit'] if metric['unit']
      config
    end

    def self.colorize(point, alarm)
      point = point.round(1).to_s
      return point unless alarm
      if /^[<>=]/ !~ alarm
        res = @client.describe_alarms({
                                        alarm_names: [alarm]
                                      })
        metric_alarm = res.metric_alarms.first
        alarm = OPERATORS[metric_alarm.comparison_operator] + metric_alarm.threshold.to_s
      end
      point = point.red if eval("#{point} #{alarm}")
      point
    end
  end
end
