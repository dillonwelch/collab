# frozen_string_literal: true

module ApplicationHelper
  # Adds the appropriate Bootstrap classes based on whether the current page matches the link or not.
  # @param name [String] Text to display on the link.
  # @param url [String] URL for the link to link out to.
  # @see link_to
  def header_item(name, url)
    options = if request.original_fullpath == url
                { class: 'nav-link active', 'aria-current' => 'page' }
              else
                { class: 'nav-link' }
              end
    link_to(name, url, options)
  end
end
