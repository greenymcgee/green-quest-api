require "test_helper"

class IgdbFieldsHelperTest < ActionView::TestCase
  setup { @game = Game.new(igdb_id: 1026) }

  test "#get_present_value should return the new_value when it is present" do
    result = get_present_value(@game.name, "new name")
    assert_equal result, "new name"
  end

  test "#get_present_value should return the current_value when new_value is blank" do
    result = get_present_value(@game.name, nil)
    assert_equal result, @game.name
  end

  test "#get_present_boolean_value should return the new_value when it is present" do
    result = get_present_boolean_value(true, false)
    assert_equal result, false
  end

  test "#get_present_boolean_value should return the current_value when is not a boolean" do
    result = get_present_boolean_value(true, nil)
    assert_equal result, true
  end
end
