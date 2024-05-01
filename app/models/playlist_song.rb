class PlaylistSong < ApplicationRecord
  belongs_to :playlist

  def video
    # TODO: Copypasta
    uri = URI("#{ENV['BASE_API_URL']}/videos")
    @result = JSON.parse(Net::HTTP.get(uri))
    @result["videos"].find { |hsh| hsh["video_id"] == video_id }
  end
end
