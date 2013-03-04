require 'tilt' unless defined?Tilt
require 'ui/ysd_ui_fieldset_render' unless defined?UI::FieldSetRender

module Huasi
  #
  # Gallery aspect
  #
  class GalleryAspectDelegate
    include ContentManagerSystem::Support
    
    #
    # Custom representation (the gallery)
    #
    # @param [Hash] the context
    # @param [Object] the element
    #
    def custom(context={}, element, aspect_model)
    
      app = context[:app]
      
      if element.album.nil?
        ''
      else
        aspect = aspect_model.aspect('album')
        locals = {:album_render => aspect.get_aspect_attribute_value('render')}

        renderer = ::UI::FieldSetRender.new('gallery', app)
        renderer.render('view','',locals.merge({:element => element}))
      end

    end       
    
    #
    # Information
    #
    def element_info(context={})
      app = context[:app]
      {:id => 'gallery', :description => "#{app.t.gallery.description}"} 
    end 

    # ========= Aspect config =======================
    
    #
    # The aspect configuration form
    #
    def config(context={}, aspect_model)
      
      app = context[:app]
      template_path = File.expand_path(File.join(File.dirname(__FILE__),'..',
        'views','gallery_aspect_config.erb'))
      template = Tilt.new(template_path)
      the_render = template.render(app)    
                
    end

    # ========= Entity Management extension ========= 
    
    #
    # Renders the tab
    #
    def element_form_tab(context={}, aspect_model)
      app = context[:app]
      info = element_info(context)
      render_tab("#{info[:id]}_form", info[:description])
    end

    #
    #
    #
    def element_form(context={}, aspect_model)

      app = context[:app]
      
      renderer = ::UI::FieldSetRender.new('gallery', app)      
      gallery_form = renderer.render('form', 'em')    

    end

    #
    #
    #
    def element_form_extension(context={}, aspect_model)

      app = context[:app]
             
      aspect = aspect_model.aspect('album')
    
      locals = {:photo_album_prefix => aspect.get_aspect_attribute_value('album_prefix'),
                :photo_width => aspect.get_aspect_attribute_value('album_photo_width').to_i,
                :photo_height => aspect.get_aspect_attribute_value('album_photo_height').to_i,
                :photo_accept => aspect.get_aspect_attribute_value('media_accept'),
                :photo_max_size => aspect.get_aspect_attribute_value('max_size').to_i,
                :render => aspect.get_aspect_attribute_value('render')}


      renderer = UI::FieldSetRender.new('gallery', app)      
      gallery_form_extension = renderer.render('formextension', 'em', locals)

    end

    
  end
end