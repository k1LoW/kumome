# Kumome [![Gem](https://img.shields.io/gem/v/kumome.svg)](https://rubygems.org/gems/kumome)

Resource statistics tool via AWS CloudWatch.

[![asciicast](https://asciinema.org/a/35090.png)](https://asciinema.org/a/35090?speed=5&autoplay=1)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kumome'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kumome

## Getting Started

### STEP 1. Set AWS credentials

#### 1-1. Use Shared Credentials

```sh
$ aws configure

...
```

#### 1-2. Use secrets.yml

```sh
$ cat <<EOF > spec/secrets.yml
region: ap-northeast-1
aws_access_key_id: XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EOF
```

### STEP 2. Show AWS resource statistics

```sh
$ kumome --ec2=i-123ab45c,i-890ed12c --rds=my-rds --elb=my-elb --profile mycreds
```

## (Default) Command options

```sh
$ kumome
Usage:
kumome    # OR: `kumome stat`

Options:
[--ec2=InstanceId,..]
[--rds=DBInstanceIdentifier,..]
[--elb=LoadBalancerName,..]
[--profile=PROFILE]
[--period=N]
                    # Default: 300
[--config=CONFIG]

Show AWS resource statistics
```

If you show command config YAML, run `kumome config`.

## Custom command options

Write `custom.yml`.

```yaml
---
resources:
  lambda: # "command option name"
    namespace: AWS/Lambda # required
    dimensions_name: FunctionName # required
    metrics:
      count:
        metric_name: Invocations # required
        statistic: Sum # required
        unit: Count
        alarm: '>=100' # "metric alarm name" or "operator and number"
      error:
        metric_name: Errors
        statistic: Sum
        unit: Count
        alarm: '>=5'
      duration:
        metric_name: Duration
        statistic: Average
```
( See https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-metrics.html )

And use `--config` option.

```sh
$ kumome --config=./custom.yml
Usage:
kumome    # OR: `kumome stat`

Options:
[--lambda=FunctionName,..]
[--profile=PROFILE]
[--period=N]
                    # Default: 300
[--config=CONFIG]

Show AWS resource statistics

$ kumome --config=./custom.yml --lambda=my-lambda-func-name,hook-lambda-func-name --profile mycreds
```

## TODO

- `tailf` option

## Contributing

1. Fork it ( https://github.com/k1LoW/kumome/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
