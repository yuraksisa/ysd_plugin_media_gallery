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
      
      renderer = UI::FieldSetRender.new('gallery', app)
      renderer.render('view','',{:element => element})
    
    end       
    
    #
    # Information
    #
    def element_info(context={})
      app = context[:app]
      {:id => 'gallery', :description => "#{app.t.gallery.description}"} 
    end 

    # ========= Entity Management extension ========= 
    
    #
    # Content element action
    #
    def element_action(context={}, aspect_model)
    
      app = context[:app]

      app.render_element_action_button({:title => app.t.gallery.action_button.gallery, 
                                        :text  => app.t.gallery.action_button.gallery, 
                                        :id    => 'manage_gallery' })
    
    end
    
    #
    # Content element action extension
    #
    def element_action_extension(context={}, aspect_model)
      
      app = context[:app]
            
      Plugins::Plugin.plugin_invoke_all('album_aspect_action_extension', {:app => app}, aspect_model).join
    
    end        
  
  end
end