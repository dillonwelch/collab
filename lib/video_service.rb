require "net/http"

class VideoService
  def self.get
    # TODO: cache bust?
    # TODO: enable cache
    # TODO: docs
    # TODO: pagination
    Rails.cache.fetch("video_service_get") do
      uri = URI("#{ENV['BASE_API_URL']}/videos")
      JSON.parse(Net::HTTP.get(uri))
    end
  end

  def self.get_by_video_id(video_id)
    # TODO: cache bust?
    # TODO: enable cache
    # TODO: docs
    # TODO: pagination
    Rails.cache.fetch("video_service_get_by_video_id") do
      get["videos"].map { |hsh| [hsh["video_id"], hsh] }.to_h
    end.fetch(video_id, {})
  end
end