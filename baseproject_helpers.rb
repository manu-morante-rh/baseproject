module Baseproject::BaseprojectHelpers

  # ::: body_class :::
  # ...................................................................................................
  # Insert information classes in the BODY tag
  # It provides basic information as:
  #  - controller,
  #  - controller-child_controller,
  #  - controller-child_controller-action
  # logged-in                             - Cuando se está logado (con cualquier tipo de permiso)
  def body_class
    class_body = "#{body_class_from_controller_path(controller_path)} #{body_class_from_controller_path(controller_path).split(" ").last}-#{action_name}"
    #class_body += " logged-in" if exists_current_user? || exists_current_admin?
    #class_body += " user-logged-in" if exists_current_user?
    class_body += " #{Rails.env}"
    class_body += " lang-#{I18n.locale.to_s}"
    class_body
  end

  def body_class_from_controller_path(path)
    body_class = ""

    path.split("/").each do |controller|
      if controller == path.split("/").first
        body_class = controller
      else
        body_class += " #{body_class.split(" ").last}-#{controller}"
      end
    end

    body_class
  end

  # ::: bp_html_tag ::: #21/03/2013 @manu
  # ...................................................................................................
  # Define HTML tag with IE conditionals (based on html5boilerplate.com)
  def bp_html_tag
    html = <<-HTML
      <!--[if lt IE 7]> <html class="lt-ie7" lang="es"> <![endif]-->
      <!--[if IE 7]>    <html class="ie7" lang="es">    <![endif]-->
      <!--[if IE 8]>    <html class="ie8" lang="es">    <![endif]-->
      <!--[if IE 9]>    <html class="ie9" lang="es">    <![endif]-->
      <!--[if gt IE 9]> <!--> <html lang="es">          <!--<![endif]-->
    HTML
    html.html_safe
  end

  # ::: bp_class ::: #31/05/2012
  # ...................................................................................................
  # Format and clean class strings
  def bp_class class_param
    class_param.blank? ? '' : class_param.strip().html_safe
  end

  # ::: bp_html_print ::: #31/05/2012
  # ...................................................................................................
  # Format and print final HTML code
  # Supports: crude html code
  # Returns: Safe html without spaces
  def bp_html_print html
    if html.blank?
      out = 'The helper <b>bp_html_print</b> received <b>empty</b> or <b>null</b>.'
    else
      out = html.gsub(/  /, ' ')
      out = out.gsub('id=""', '')
      out = out.gsub('class=""', '')
      out = out.gsub('style=""', '')
    end

    out.try(:html_safe)
  end

  # ::: bp_buttons ::: #18/03/2013
  # ...................................................................................................
  # Creates a space for buttons
  def bp_buttons(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      bp_buttons(capture(&block), options, html_options)
    else
      html_buttons = args.first
      options = args.second || {}
      options_hash = options

      options_hash[:class] = options[:class].blank? ? 'bp-box-buttons' : bp_class("bp-box-buttons #{options[:class]}")
      label = options[:label].blank? ? '' : content_tag(:div, bp_html_print(options[:label]), :class=>'label')

      out = label
      out += html_buttons

      content_tag :div, bp_html_print(out), options_hash
    end
  end

  # ::: bp_button :::
  # ...................................................................................................
  # Default button helper
  def bp_button(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      bp_button(capture(&block), options, html_options)
    else
      label   = args.first
      href    = args.second || '#'
      options = args.third || {}
      options_hash = options

      options_hash[:class] = options[:class].blank? ? 'btn' : bp_class("btn #{options[:class]}")

      out = label
      out += '<i></i>'.html_safe

      content_tag :div, link_to(bp_html_print(out), href), options_hash
    end
  end

  # ::: bp_submit :::
  # ...................................................................................................
  def bp_submit(*args, &block)
    if block_given?
      "No admite &block"
    else
      label   = args.first
      options = args.second || {}
      #options_hash = options # Para que reciba cualquier atributo (sin filtrar)
      options_hash = {}

      options_hash[:class] = options[:class].blank? ? "btn" : bp_class("btn #{options[:class]}")

      if !options[:id].blank?
        options_hash[:id] = options[:id]
      end

      if options[:input_id].blank?
        input_id = options_hash[:id].blank? ? "" : "input_#{options_hash[:id]}"
      else
        input_id = options[:input_id]
      end

      input_hash = {}
      input_hash[:id] = input_id

      content_tag :div, options_hash do
        submit_tag label, input_hash
      end
    end
  end

  # ::: bp_group :: (ANTES group_inputs_form)
  # ...................................................................................................
  # Agrupar elementos
  # Admite: Label, ID y Class
  def bp_group options, &block
    label = options[:label].blank? ? "" : options[:label]
    id = options[:id].blank? ? "" : options[:id]
    style = options[:style].blank? ? "" : options[:style]

    out = content_tag :li, :class => bp_class("group #{options[:class]}"), :id => "#{id}", :style => style do
      content_tag :fieldset do
        fieldset = label.blank? ? "" : content_tag(:legend, label, :class => "label")
        fieldset += content_tag(:ol, capture(&block))
        fieldset.html_safe
      end
    end

    bp_html_print out
  end

  # ::: bp_inline :: (ANTES inline_inputs_form)
  # ...................................................................................................
  # Campos en linea
  # Admite: Label, ID y Class
  def bp_inline options, &block

    label = options[:label].blank? ? "" : options[:label]
    not_label = label.blank? ? "not-label" : ""
    id = options[:id].blank? ? "" : "id='#{options[:id]}'"

    cols = options[:cols].blank? ? "" : "cols-#{options[:cols]}"
    msgerr = cols.blank? ? "No se ha definido el numero de columnas <b>:cols</b>" : ""

    unless msgerr.blank?
      out = msgerr
    else

      out = content_tag :li, :class => bp_class("inline #{cols} #{not_label} #{options[:class]}"), :id => "#{id}" do
        content_tag :fieldset do
          fieldset = label.blank? ? "" : content_tag(:legend, label, :class => "label")
          fieldset += content_tag :ol, capture(&block)
          fieldset = fieldset.html_safe
        end
      end

    end

    bp_html_print out
  end

  # ::: bp_tabs ::
  # ...................................................................................................
  # Pestañas y su contenedos.
  # Se usa junto al def "bp_tab"
  # Admite:
  #   :titles   - serán los titulos de las pestañas
  #   :ids      - id de cada tab
  #   :active   - activa el tab indicado en active
  def bp_tabs options, &block

    id = options[:id] # ID del grupo de tabs
    ids = options[:ids] # Grupo de IDS personalizados para nuestros tabs
    active = options[:active].to_i
    active = active<=1 ? 1 : active

    out = "<div class='#{bp_class("bp-tabs #{options[:class]}")}' id='#{id}'>"

    ul = ''
    options[:titles].each_with_index do |title, index|
      active_class = (index+1 == active) ? 'active' : ''
      id_title = ids.blank? ? "#{id}-#{index+1}" : "#{id}-#{ids[index]}"
      id_class = ids ? ids[index] : ''
      ul += content_tag :li, :id => "title-#{id_title}", :class => bp_class("tab-#{index+1} #{id_class} #{active_class}") do
        content_tag :a, title, :href => "##{id_title}"
      end
    end
    out += content_tag :ul, ul.html_safe, :class => 'tabs-titles'
    out += content_tag :div, capture(&block), :class => "bp-tabs-content"
    out += "</div>"

    bp_html_print out
  end

  def bp_tab options, &block
    content_tag(:div, capture(&block), :class => bp_class("bp-tab-content tab-#{options[:tab]} #{options[:class]}"), :id => "#{options[:id]}-#{options[:tab]}").html_safe
  end


  # ::: action_button :::
  # ...................................................................................................
  # Boton de estilo Accion (accion positiva)
  # Muestra un enlace A con estilo Accion
  # Admite: Label, URL y clases adicionales
  def action_button_form options
    label = options[:label] ? options[:label] : "Boton"
    url = options[:url] ? options[:url] : "#"
    myclass = options[:class] ? "btn-action #{options[:class]}" : "btn-action"

    "<li><div class='#{myclass}'>#{link_to(label, url)}</div></li>".html_safe
  end

  # ::: cancel_button :::
  # ...................................................................................................
  # Boton de estilo Cancelar (accion negativa)
  # Muestra un enlace A con estilo Cancelar y el texto Cancelar
  # Admite: Label, URL y clases adicionales
  def cancel_button_form options
    label = options[:label] ? options[:label] : "Cancelar"
    url = options[:url] ? options[:url] : "#"
    myclass = options[:class] ? "btn-action btn-cancel #{options[:class]}" : "btn-action btn-cancel"
    link = options[:fancybox] ? link_to_function(label, "$.fancybox.close()") : link_to(label, url)
    "<li><div class='#{myclass}'>#{link}</div></li>".html_safe
  end

  # ::: custom_item :::
  # ...................................................................................................
  # Elemento personalizado: texto, link,...
  # Admite: ID, label, hint, HTML
  # Ejemplo:
  # custom_item_form :label => 'Visita mi web', :html => link_to('miweb.es','http://www.miweb.es/')
  def custom_item_form options
    group_html = "<li id='#{options[:id]}' class='p'>"
    group_html += options[:label] ? "<label for='#{options[:id]}'>#{options[:label]}</label>" : ""
    group_html += "<div class='wrap-custom-html'>#{options[:html]}</div>"
    group_html += options[:hint] ? "<p class='inline-hints'>#{options[:hint]}</p>" : ""
    group_html += "</li>"
    group_html.html_safe
  end

  def errors_inputs_form options

    options[:inputs].each do |key, value|
      group_html += "key: #{key} - value: #{value}"
      # resource.errors[:name] 
    end

    group_html.html_safe
  end

end

# ::: bp_directory_index :::
# Muestra un arbol de carpetas y vistas en funcion del path del request
def bp_directory_index
  tree_hash = BP.same_level_views("/base_project#{request.env['PATH_INFO']}")

  p tree_hash

  out = "<ul>"

  tree_hash.keys.each do |tree_hash_key|
    thk = tree_hash_key.gsub(".html.erb", "")
    thk = thk.gsub("/mocks", "")

    out += content_tag :li, thk.gsub("/", "")

    out += "<ul>"
    tree_hash[tree_hash_key].each do |tree_hash_value|
      thv = tree_hash_value.gsub(".html.erb", "")
      if thv != "index"
        out += content_tag :li, link_to("#{thv}", "/mocks?t=#{thk}/#{thv}")
      end

    end
    out += "</ul>"

    out += "</li>"
  end
  out += "</ul>"

  out.html_safe
end

# ::: bp_mock_directory_index :::
# Muestra un arbol de carpetas y vistas dentro de la carpeta mocks
def bp_mock_directory_index

  tree_hash = BP.same_level_views("/mocks")

  out = "<ul>"

  tree_hash.keys.each do |tree_hash_key|
    thk = tree_hash_key.gsub(".html.erb", "")
    thk = thk.gsub("/mocks", "")

    out += content_tag :li, thk.gsub("/", "")

    out += "<ul>"
    tree_hash[tree_hash_key].each do |tree_hash_value|
      thv = tree_hash_value.gsub(".html.erb", "")
      if thv != "index"
        out += content_tag :li, link_to("#{thv}", "/mocks/no_layout?t=#{thk}/#{thv}")
      end

    end
    out += "</ul>"

    out += "</li>"
  end
  out += "</ul>"

  out.html_safe
end

# ::: bp_meta_tags  :::  #31/05/2012
# ...................................................................................................
# Add baseproject meta tags
def bp_meta_tags
  "<meta name='base-project-version' content='#{bp_version}'>".html_safe
end
