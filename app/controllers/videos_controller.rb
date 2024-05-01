require "net/http"
class VideosController < ApplicationController
  def index
    uri = URI("#{ENV['BASE_API_URL']}/videos")
    @result = JSON.parse(Net::HTTP.get(uri))
  end
end
