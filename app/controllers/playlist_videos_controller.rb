require "net/http"

class PlaylistVideosController < ApplicationController
  def create
    # begin
      # VideoService.stub "get", [{}] do
      #   puts "playlist video controller: #{request.original_url} "
      #   puts "controller get 1: #{VideoService.get}"
      #   puts "controller get id 1: #{VideoService.get_by_video_id('123')}"
        # TODO: proper error response
    puts "start of pv controller"
        @playlist_video = PlaylistVideo.new(playlist_video_params)
    puts "after new"
    puts "omg pls wkfjdlkj: #{@playlist_video.video}"
        @playlist_video.save!
      # end
    # rescue Exception => e
    #   raise e.message
    # end
  end

  private

  def playlist_video_params
    params.require(:playlist_video).permit(:playlist_id, :video_id, :position)
  end
end
