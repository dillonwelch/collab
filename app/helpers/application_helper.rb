module ApplicationHelper
  # TODO: docs
  # TODO: test
  def header_item(name, url)
    if request.original_fullpath == url
      options = { class: "nav-link active", "aria-current" => "page" }
    else
      options = { class: "nav-link" }
    end
    link_to(name, url, options)
  end
end
