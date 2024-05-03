# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'test_helpers/video_service_helper'

module ActiveSupport
  class TestCase
    include VideoServiceHelper

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    require 'webmock/minitest'
    WebMock.disable_net_connect!(allow_localhost: true)
    VCR.configure do |config|
      config.cassette_library_dir = 'test/cassettes'
      config.hook_into :webmock
      config.ignore_localhost = true
      config.ignore_hosts ['chromedriver.storage.googleapis.com', '127.0.0.1']
    end
  end
end
