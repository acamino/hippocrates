module ApplicationHelper
  def error_messages_for(resource, display_header = true)
    if resource.errors.any?
      header = display_header ? content_tag(:b, 'Por favor corrige los siguiente errores:') : ''
      body = content_tag(:ul, resource.errors.full_messages.map { |message| content_tag(:li, message) }.join, {}, false)
      content_tag(:div, "#{header} #{body}".html_safe, class: "text-danger")
    end
  end

  def nav_to(nav_text, nav_path)
    class_name = nav_path.include?(params[:controller]) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to(nav_text, nav_path)
    end
  end

  def consultations?
    params[:controller] == "consultations" && params[:action] == "new"
  end
end
