module ApplicationHelper
  def present_for(object)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object)
    yield presenter
  end

  def error_messages_for(resource, display_header = true)
    return nil unless resource.errors.any?

    error_messages = resource.errors.full_messages.map do |message|
      content_tag(:li, message)
    end.join
    header = display_header ? content_tag(:b, 'Por favor corrige los siguiente errores:') : ''
    body = content_tag(:ul, error_messages, {}, false)
    content_tag(:div, "#{header} #{body}".html_safe, class: 'text-danger')
  end

  def nav_to(nav_text, nav_path)
    current_action = params[:action] == 'index' ? '' : params[:action]
    computed_path  = "/#{[params[:controller], current_action].reject(&:empty?).join('/')}"
    class_name     = nav_path == computed_path ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to(nav_text, nav_path)
    end
  end

  def active_nav_to(nav_text, nav_path)
    content_tag(:li, class: 'active') do
      link_to(nav_text, nav_path)
    end
  end

  def gender_tag(patient)
    if patient.male?
      content_tag(:i, nil, class: 'fa fa-male')
    else
      content_tag(:i, nil, class: 'fa fa-female')
    end
  end
end
