require "net/http"

# A service used to interact with the Video API. The results are cached so that we do not have to repeatedly hit an
# external API. The decision was made to store video data within this service as it makes data integrity a lot
# simpler to manage. Put another way, if we stored the API results in the database, we would have to do a full upsert
# scan each time we cache busted in order to make sure things were synced. The approach used here would facing scaling
# issues if the video API returned a large amount of results. In that scenario, it would be prudent to do the extra
# work to save the data in the database.
# @note Requires ENV['BASE_API_URL'] to be set.
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
  # @param api_page_size [Integer] The page size of the results that come back from the Video API. Defaults to 20 based
  #   on test API used during development.
  # @return [Array<Hash>] The list of videos from the Video API.
  def self.get(api_page_size: 20)
    Rails.cache.fetch(CACHE_KEYS[__method__]) do
      page = 1
      data = []
      while true do
        uri = URI("#{ENV['BASE_API_URL']}/videos?page=#{page}")
        result = JSON.parse(Net::HTTP.get(uri))
        data += result["videos"]
        page += 1
        break if result["videos"].length < api_page_size
      end
      data
    end
  end

  # Returns the JSON parsed data from the Video API for a specific video, based on video_id. Will iterate through the
  # paginated API until no more results are  found. Results are cached. Use VideoService.cache_bust to clear the cache.
  # @return [Hash] The JSON data for the video, or an empty array if nothing was found.
  # @see VideoService.get which is used internally for fetching the data.
  def self.get_by_video_id(video_id)
    Rails.cache.fetch(CACHE_KEYS[__method__]) do
      VideoService.get.each_with_object(Hash.new({})) { |item, hash| hash[item["video_id"]] = item }
    end[video_id]
  end
end