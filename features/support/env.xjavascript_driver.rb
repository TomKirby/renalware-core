# frozen_string_literal: true

require "capybara/poltergeist"

# When this option is enabled, you can insert page.driver.debug into your tests
# to pause the test and launch a browser which gives you the WebKit inspector
# to view your test run with.
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    inspector: "open",
    window_size: [1366, 1768],
    debug: true
  )
end

Capybara.register_driver :poltergeist_large_window do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    window_size: [1366, 1768]
  )
end

Capybara.javascript_driver = :poltergeist_large_window

if RUBY_PLATFORM.match?(/darwin/)
  Capybara::Screenshot.register_driver(:poltergeist_large_window) do |_driver, _path|
    # noop
  end
end

# Capybara.javascript_driver = :poltergeist_debug
