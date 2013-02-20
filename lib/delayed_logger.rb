require "delayed_logger/version"
require 'logger'

class DelayedLogger
  attr_accessor :delayed_level
  
  def initialize(logger = nil)
    if logger.nil?
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
    end
    @logger = logger
    @delayed = false
    @delayed_level = Logger::DEBUG
  end

  def capture
    start_capture
    begin
      yield
    ensure
      end_capture
    end
  end

  def flush_captured_logs
    @logger.add(@logger.level, 'DelayedLogger: BEGIN flushing captured logs')
    @logger << @delayed_logs
    @logger.add(@logger.level, 'DelayedLogger: END flushing captured logs')
  end

  def start_capture
    @delayed_logs = ""
    @delayed = true
    nil
  end

  def end_capture
    @delayed_logs = ""
    @delayed = false
    nil
  end

  def add(severity, message = nil, progname = nil, &block)
    severity ||= Logger::UNKNOWN
    if severity < @delayed_level
      return true
    end
    if @delayed && severity < @logger.level
      progname ||= @progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
      @delayed_logs << @logger.send(:format_message, 
        @logger.send(:format_severity, severity),
        Time.now,
        progname,
        message)
    else
      @logger.add(severity, message, progname, &block)
    end
    true
  end

  def method_missing(meth, *args, &block)
    @logger.send(meth, *args, &block)
  end

  def debug(progname = nil, &block)
    add(Logger::DEBUG, nil, progname, &block)
  end

  def info(progname = nil, &block)
    add(Logger::INFO, nil, progname, &block)
  end

  def warn(progname = nil, &block)
    add(Logger::WARN, nil, progname, &block)
  end

  def error(progname = nil, &block)
    add(Logger::ERROR, nil, progname, &block)
  end

  def fatal(progname = nil, &block)
    add(Logger::FATAL, nil, progname, &block)
  end

  def unknown(progname = nil, &block)
    add(Logger::UNKNOWN, nil, progname, &block)
  end
end
