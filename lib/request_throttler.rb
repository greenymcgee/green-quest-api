class RequestThrottler
  def initialize(calls_per_second: 3)
    @interval = 1.0 / calls_per_second.to_f
    @last_call_time = nil
  end

  def throttle
    sleep_for_interval_duration
    @last_call_time = Time.now
    yield
  end

  private

  def sleep_for_interval_duration
    return unless @last_call_time.present?

    elapsed_time = Time.now - @last_call_time
    return unless elapsed_time < @interval

    sleep(@interval - elapsed_time)
  end
end
