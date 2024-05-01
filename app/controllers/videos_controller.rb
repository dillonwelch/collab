class VideosController < ApplicationController
  def index
    @result = VideoService.get
  end
end
