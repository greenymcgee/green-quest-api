class AddPlatformToPlatformLogos < ActiveRecord::Migration[7.2]
  def change
    add_reference :platform_logos, :platform
  end
end
