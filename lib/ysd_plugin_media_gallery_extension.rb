require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# MediaGallery Extension
#
module Huasi

  class MediaGalleryExtension < Plugins::ViewListener
                
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
  
  
  end #MailExtension
end #Social