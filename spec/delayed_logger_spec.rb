require 'spec_helper'

describe DelayedLogger do
  let(:output) { StringIO.new }
  let(:logger) {
    logger = DelayedLogger.new(Logger.new(output))
    logger.level = Logger::INFO
    logger
  }

  describe 'without delaying' do
    before do
      logger.info('foo')
      logger.debug('bar')
    end

    it 'should output INFO' do
      output.string.should match(/foo/)
    end

    it 'should not output DEBUG' do
      output.string.should_not match(/bar/)
    end
  end

  describe 'when delayed' do
    before do
      logger.start_capture
      logger.info('foo')
      logger.debug('bar')
    end

    it 'should output INFO' do
      output.string.should match(/foo/)
    end

    it 'should not output DEBUG' do
      output.string.should_not match(/bar/)
    end

    describe 'after flushing capture' do
      before do
        logger.flush_captured_logs
        logger.end_capture
      end

      it 'should output DEBUG' do
        output.string.should match(/bar/)
      end
    end

    describe 'when limited to 10 entries, with many logs' do
      before do
        logger.max_lines = 10
        15.times {|i| logger.debug("line #{i}") }
      end

      it 'should have 10 entries' do
        logger.delayed_logs.size.should == 10
      end

      it 'should have newest log entry' do
        logger.delayed_logs.last.should match(/line 14/)
      end
    end
  end
end
