require "delayed_logger/version"
require 'logger'

class DelayedLogger
  attr_accessor :delayed_level, :max_lines
  attr_reader :delayed_logs
  
  # Logging severity.
  module Severity
    # Low-level information, mostly for developers
    DEBUG = 0
    # generic, useful information about system operation
    INFO = 1
    # a warning
    WARN = 2
    # a handleable error condition
    ERROR = 3
    # an unhandleable error that results in a program crash
    FATAL = 4
    # an unknown message that should always be logged
    UNKNOWN = 5
  end
  include Severity
  
  def initialize(logger = nil)
    if logger.nil?
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
    end
    @logger = logger
    @delayed = false
    @delayed_level = Logger::DEBUG
    @max_lines = 1000
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
    @logger << @delayed_logs.join
    @logger.add(@logger.level, 'DelayedLogger: END flushing captured logs')
  end

  def start_capture
    @delayed_logs = []
    @delayed = true
    nil
  end

  def end_capture
    @delayed_logs = []
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
      @delayed_logs.shift if @delayed_logs.size > @max_lines
    else
      @logger.add(severity, message, progname, &block)
    end
    true
  end

  def method_missing(meth, *args, &block)
    @logger.send(meth, *args, &block)
  end

  def debug?; @delayed_level <= DEBUG; end
  def info?; @delayed_level <= INFO; end
  def warn?; @delayed_level <= WARN; end
  def error?; @delayed_level <= ERROR; end
  def fatal?; @delayed_level <= FATAL; end

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
