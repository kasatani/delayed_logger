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
  end
end
