module RemoteLinkPaginationHelper
  require 'will_paginate/view_helpers/link_renderer'
  require 'will_paginate/view_helpers/action_view'  
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    def link(text, target, attributes = {})
      attributes['data-remote'] = true
      super
    end
  end
end