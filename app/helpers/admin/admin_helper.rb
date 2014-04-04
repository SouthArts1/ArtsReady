module Admin
  module AdminHelper
    def menu_item(body, url)
      content_tag 'li', class: ('active' if request.path.starts_with?(url)) do
        link_to body, url
      end
    end
  end
end