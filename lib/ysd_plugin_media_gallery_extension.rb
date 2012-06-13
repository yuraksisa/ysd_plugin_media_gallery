# encoding: UTF-8

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

    # ========= Page Building ============

    #
    # It gets the style sheets defined in the module
    #
    # @param [Context]
    #
    # @return [Array]
    #   An array which contains the css resources used by the module
    #
    def page_style(context={})
      ['/photo_gallery/css/jquery.ad-gallery.css']     
    end
 
    #
    # It gets the scripts used by the module
    #
    # @param [Context]
    #
    # @return [Array]
    #   An array which contains the css resources used by the module
    #
    def page_script(context={})
    
      ['/js/ysd.events.js',
       '/js/ysd.dialogs.js',
       '/photo_gallery/js/jquery.ad-gallery.js']   
    
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
  
  
  end #MailExtension
end #Social