# A helper for IGDB setting values in this db with IGDB fields that were
# fetched.
module IgdbFieldsHelper
  # This is useful for ensuring that no attempts are made to set default values
  # to nil which will cause a PGError due to the null: false in the schema.
  def get_present_value(current_value, new_value)
    return new_value if new_value.present?

    current_value
  end

  def get_present_boolean_value(current_bool, new_bool)
    return new_bool if [true, false].include? new_bool

    current_bool
  end
end
