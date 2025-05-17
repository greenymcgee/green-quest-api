class RequestThrottlerRegistry
  include Singleton

  def initialize
    @throttler = RequestThrottler.new
  end

  def throttle(&block)
    @throttler.throttle(&block)
  end

  def replace_throttler(throttler)
    @throttler = throttler
  end
end
