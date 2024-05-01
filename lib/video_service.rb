require "net/http"

class VideoService
  def self.get
    # TODO: cache bust?
    Rails.cache.fetch("video_service") do
      uri = URI("#{ENV['BASE_API_URL']}/videos")
      JSON.parse(Net::HTTP.get(uri))
    end
  end

  def self.get_by_video_id(video_id)
    get["videos"].find { |hsh| hsh["video_id"] == video_id } || {}
  end
end