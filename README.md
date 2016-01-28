# Kumome [![Gem](https://img.shields.io/gem/v/kumome.svg)](https://rubygems.org/gems/kumome)

Resource statistics tool via AWS CloudWatch.

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

## TODO

- `tailf` option

## Contributing

1. Fork it ( https://github.com/k1LoW/kumome/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
