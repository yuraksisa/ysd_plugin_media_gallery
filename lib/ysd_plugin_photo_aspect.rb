require 'ui/ysd_ui_fieldset_render' unless defined?UI::FieldSetRender

module Huasi
  #
  # Photo aspect
  #
  class PhotoAspectDelegate
    include ContentManagerSystem::Support
    
    #
    # Information
    #
    def element_info(context={})
      app = context[:app]
      {:id => 'photo', :description => "#{app.t.content.content_photo.description}"} 
    end 
    
    # ========= Aspect config =======================
    
    #
    # The aspect configuration form
    #
    def config(context={}, aspect_model)
      
      app = context[:app]
      template_path = File.expand_path(File.join(File.dirname(__FILE__),'..','views','photo_aspect_config.erb'))
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
    # Add fields to edit the photo information in the content form
    #
    def element_form(context={}, aspect_model)
      
      app = context[:app]
      
      renderer = ::UI::FieldSetRender.new('photo', app)      
      photo_form = renderer.render('form', 'em')     
    
    end
    
    #
    # Support to edit the photo information in the content form
    #
    def element_form_extension(context={}, aspect_model)
    
      app = context[:app]
    
      aspect = aspect_model.aspect('photo')
    
      locals = {:photo_album => aspect.get_aspect_attribute_value('album_name'),
                :photo_width => aspect.get_aspect_attribute_value('album_photo_width').to_i,
                :photo_height => aspect.get_aspect_attribute_value('album_photo_height').to_i,
                :photo_accept => aspect.get_aspect_attribute_value('media_accept'),
                :photo_max_size => aspect.get_aspect_attribute_value('max_size').to_i}
         
      renderer = UI::FieldSetRender.new('photo', app)      
      photo_form_extension = renderer.render('formextension', 'em', locals)
              
    end
    
    #
    # Renders the tab
    #
    def element_template_tab(context={}, aspect_model)
      app = context[:app]
      info = element_info(context)
      render_tab("#{info[:id]}_template", info[:description])
    end    
    
    #
    # Show the photo information in the content render
    #
    def element_template(context={}, aspect_model)
    
       app = context[:app]
    
       renderer = ::UI::FieldSetRender.new('photo', app)      
       photo_template = renderer.render('view', 'em')
                
    end

  
  end
end