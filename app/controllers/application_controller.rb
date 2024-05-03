# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action do
    VideoService.cache_bust if params[:cache_bust] == 'true'
  end
end
