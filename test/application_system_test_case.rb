require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end


RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end