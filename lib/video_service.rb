require "net/http"

class VideoService
  CACHE_KEYS = {
    get: :video_service_get,
    get_by_video_id: :video_service_get_by_video_id
  }

  # TODO: docs
  def self.cache_bust
    CACHE_KEYS.values.each do |key|
      Rails.cache.delete(key)
    end
  end

  def self.get
    # TODO: enable cache
    # TODO: docs
    # TODO: pagination
    Rails.cache.fetch(CACHE_KEYS[__method__]) do
      page = 1
      # TODO: do I need it hashed
      data = { "videos" => [] }
      while true do
        uri = URI("#{ENV['BASE_API_URL']}/videos?page=#{page}")
        result = JSON.parse(Net::HTTP.get(uri))
        if result["videos"].present?
          data["videos"] += result["videos"]
          page += 1
        else
          # TODO: can calculate this via page size
          break
        end
      end
      data
    end
  end

  def self.get_by_video_id(video_id)
    # TODO: enable cache
    # TODO: docs
    # TODO: pagination
    Rails.cache.fetch(CACHE_KEYS[__method__]) do
      get["videos"].each_with_object(Hash.new({})) { |item, hash| hash[item["video_id"]] = item }
    end[video_id]
  end
end