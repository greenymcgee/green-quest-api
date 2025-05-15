require "test_helper"

class RequestThrottlerTest < ActiveSupport::TestCase
  test "should yield the block and return its value" do
    throttler = RequestThrottler.new
    result = throttler.throttle { :ok }
    assert_equal :ok, result
  end

  test "should delay execution to respect rate limit" do
    throttler = RequestThrottler.new(calls_per_second: 2)
    throttler.throttle { :first }
    second_time = Time.now
    throttler.throttle { :second }
    third_time = Time.now
    elapsed_time = third_time - second_time
    assert_operator elapsed_time, :>=, 0.5
  end
end
