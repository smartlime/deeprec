module ApplicationHelper
  def navbar_item(name = nil, options = nil, html_options = nil, &block)
    link = link_to(name, options, html_options, &block)
    is_active = url_for(block_given? ? name : options) == request.env['PATH_INFO']
    "<li#{is_active ? ' class="active"' : ''}>#{link}</li>".html_safe
  end

  def glyph(name)
    "<span class=\"glyphicon glyphicon-#{name}\" aria-hidden=\"true\"></span>".html_safe
  end
end
