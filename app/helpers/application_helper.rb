module ApplicationHelper
  # Adds the appropriate Bootstrap classes based on whether the current page matches the link or not.
  # @param name [String] Text to display on the link.
  # @param url [String] URL for the link to link out to.
  # @see link_to
  def header_item(name, url)
    if request.original_fullpath == url
      options = { class: "nav-link active", "aria-current" => "page" }
    else
      options = { class: "nav-link" }
    end
    link_to(name, url, options)
  end

  # TODO: Do we still need this and if so document it and test
  def flash_mapper(type)
    {
      "alert" => "danger",
      "notice" => "info"
    }[type]
  end
end
