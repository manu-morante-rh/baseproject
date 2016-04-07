# Front-end Rails Helpers

it's powerful, it's for ruby​​!

## Changelog:

#### 28/05/2012
  - NUEVO helper para botones! bp_button, bp_send!...
  - Rediseño de administracion. Con capacidades "responsive webdesign"
  - Nuevo sistema de maquetas dinamicas "mocks". localhost:3000/mocks Muestra un arbol de directorios y archivos con todas las maquetas disponibles.
  - Ahora puedes ver la maqueta con o sin layout localhost:3000/mocks/no_layout/

#### 31/05/2012

  - Helper bp_html_print. Se usa para pintar el HTML de todos los demsa helpers, de forma correcta.
  - Helper 'bp_meta_tags' para pintar la etiqueda meta de la version de proyecto base.

#### 21/05/2012

  - Nuevo Helper "bp_custom_item" para items personalizados que mantengan la estrucutra en un formulario.
  - Refactor de todos los helper actuales a uso de "content_tag".

#### 02/11/11

  - Nuevo Helper para Grupos bp_group. Uso por agrupacion de codigo.
  - Cambio de Helper inline. Renombrado de inline_inputs_form a bp_inline. Su uso es distinto, por agrupacion de codigo igual a bp_group.
  - Helper para Tabs "bp_tabs" y "bp_tab". Ha cambiado el JavaScript. Se recomienda actualizar y cambiar el html.
  - Tabs BP_TABS.
  - Ahora es posible tener varios grupos de pestañas.
  - Se ha creado la etiqueta meta-tag: <meta name="base-project-version" content="x.x.x">.
  - Se quita el texto "Version X.X.X" en la "admin".

#### 25/10/11

  - WYSIWYG. YUI Yahoo. rename: rich_text_editor => wysiwyg.
  - blueprint.css y formtastic.css se juntan en base-project.css.
  - formtastic_herlper.rb y admin_helper.rb se juntan en base_project_helper.rb.
  - formtastic.js se convierte en base-project.js.
  - BentonSansComp_Medium_500.font.js => BentonSansCond.font.js.
  - Eliminada limitacion en anchura min/max a los fieldset en admin_general.css.
  - Breadcrumb.
  - Helper body_class.
  - Grid de columnas.
  - Organizacion de archivos. Creacion de admin_helper.rb.
  - Helper controlador de estados de actibo automaticos por URL.
  - Diseño y estructura de submenu.
  - Menu con estados de activo por CSS.
  - Forms adaptables y titulos de vista.
  - Diseño liquido (flexible).
  - Estructura.
