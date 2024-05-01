require "net/http"

# A service used to interact with the Video API. The results are cached so that we do not have to repeatedly hit an
# external API. The decision was made to store video data within this service as it makes data integrity a lot
# simpler to manage. Put another way, if we stored the API results in the database, we would have to do a full upsert
# scan each time we cache busted in order to make sure things were synced. The approach used here would facing scaling
# issues if the video API returned a large amount of results. In that scenario, it would be prudent to do the extra
# work to save the data in the database.
class VideoService
  # method => cache_key_name
  CACHE_KEYS = {
    get: :video_service_get,
    get_by_video_id: :video_service_get_by_video_id
  }

  # Will clear all caches so that data will be refreshed.
  # @see VideoService::CACHE_KEYS for list of keys that will be cleared.
  def self.cache_bust
    CACHE_KEYS.values.each do |key|
      Rails.cache.delete(key)
    end
  end

  # Returns the JSON parsed data from the Video API. Will iterate through the paginated API until no more results are
  # found. Results are cached. Use VideoService.cache_bust to clear the cache.
  # @note Requires ENV['BASE_API_URL'] to be set.
  def self.get
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