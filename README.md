# DelayedLogger

delayed_logger captures the log and lets you write the log to the logfile only when you need it, after you run the code. It is useful when you only need DEBUG logs when your code throws an exception or when it takes too long to run.

## Installation

Add this line to your application's Gemfile:

    gem 'delayed_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delayed_logger

## Usage

```ruby
require 'delayed_logger'

out = Logger.new(STDOUT)
out.level = Logger::INFO
logger = DelayedLogger.new(out)
logger.capture do
  begin
    logger.info 'info message'
    logger.debug 'debug message'
    raise 'error'
  rescue
    logger.flush_captured_logs
    raise
  end
end
```

Output:

```
I, [2013-02-20T23:17:25.040356 #27493]  INFO -- : info message
I, [2013-02-20T23:17:25.041076 #27493]  INFO -- : DelayedLogger: BEGIN flushing captured logs
D, [2013-02-20T23:17:25.041013 #27493] DEBUG -- : debug message
I, [2013-02-20T23:17:25.041135 #27493]  INFO -- : DelayedLogger: END flushing captured logs
-:10:in `block in <main>': error (RuntimeError)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
