class RequestThrottlerRegistry
  include Singleton

  def initialize
    @throttler = RequestThrottler.new
  end

  def throttle(&block)
    @throttler.throttle(&block)
  end
end
