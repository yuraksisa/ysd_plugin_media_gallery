# encoding: utf-8
require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# MediaGallery Extension
#
module Huasi

  class MediaGalleryExtension < Plugins::ViewListener


    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})
            
        SystemConfiguration::Variable.first_or_create({:name => 'photo_default_adapter'}, 
                                                      {:value => '', :description => 'Adaptador por defecto para la integración con álbumes de fotografía', :module => :media_gallery}) 
                                                      
        SystemConfiguration::Variable.first_or_create({:name => 'photo_default_account'}, 
                                                      {:value => '', :description => 'Cuenta por defecto para acceder al proveedor de álbumes de fotografía. Una de las cuentas configuradas en cuentas servicios externos', :module => :media_gallery})
                                                      
        SystemConfiguration::Variable.first_or_create({:name => 'photo_media_accept'}, 
                                                      {:value => 'image/jpeg,image/gif,image/png,image/jpeg', :description => 'Formatos de imágenes aceptados', :module => :media_gallery})
                                                      
        SystemConfiguration::Variable.first_or_create({:name => 'photo_max_size'}, 
                                                      {:value => 1000000, :description => 'Máximo tamaño de la fotografía (en bytes)', :module => :media_gallery})                                                                                                            
                                                          
    end

                
    # ========= Menu =====================
  
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #    
    def menu(context={})
       
      app = context[:app]
      
      menu_items = [{:path => '/cms/media',
                     :options => {:title => app.t.media_admin_menu.album_management,
                                  :link_route => "/album-management",
                                  :description => 'The albums admin tools to create and modify media albums.',
                                  :module => 'cms',
                                  :weight => 2}}]      
   
    end
    
    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [{:path => '/album-management',
                 :regular_expression => /^\/album-management/,
                 :title => 'Albums',
                 :description => 'The albums admin tools to create and modify media albums',
                 :fit => 1,
                 :module => :media_gallery},                 
                {:path => '/photo-management/:album_name',
                 :parent_path => '/album-management',
                 :regular_expression => /^\/photo-management\/.+/,
                 :title => 'Photos',
                 :description => 'It manages the album\'s photos. Used to upload and edit the album\'s photos.',
                 :fit => 1,
                 :module => :media_gallery},
                {:path => '/photo_gallery/album/:album_name',
                 :regular_expression => /^\/photo_gallery\/album\/.+/,
                 :title => 'Photos',
                 :description => 'It shows the album\'s photos.',
                 :fit => 1,
                 :module => :media_gallery}]
    
    end
  
    # ========= Aspects ==================
    
    #
    # Retrieve an array of the aspects defined in the plugin
    #
    # The attachment aspect (complement)
    #
    def aspects(context={})
      
      app = context[:app]
      
      aspects = []
      
      # front-page photo aspect
      aspects << ::Plugins::Aspect.new(:photo, app.t.aspect.photo, [:entity], PhotoAspectDelegate.new,
                                       [Plugins::AspectConfigurationAttribute.new(:album_name, 'album name', 'photos'),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_width, 'photo width', 640),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_height, 'photo height', 480),
                                        Plugins::AspectConfigurationAttribute.new(:media_accept, 'media accept', 'image/jpeg,image/gif,image/png,image/jpeg'),
                                        Plugins::AspectConfigurationAttribute.new(:max_size, 'max size', 3000000)])

      # album (galley) aspect
      aspects << ::Plugins::Aspect.new(:album, app.t.aspect.gallery, [:entity], GalleryAspectDelegate.new,
                                       [Plugins::AspectConfigurationAttribute.new(:album_photo_width, 'photo width', 640),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_height, 'photo height', 480),
                                        Plugins::AspectConfigurationAttribute.new(:media_accept, 'media accept', 'image/jpeg,image/gif,image/png,image/jpeg'),
                                        Plugins::AspectConfigurationAttribute.new(:max_size, 'max size', 1000000)])
                                        
      return aspects
       
    end  
  
  end #MailExtension
end #Social