# encoding: utf-8
require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener
require 'ysd_md_fieldset_album'
require 'ysd_md_fieldset_photo'

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

        SystemConfiguration::Variable.first_or_create({:name => 'media.adapter'}, 
          {:value => 'filesystem', 
           :description => 'Media adapter : filesystem or s3', 
           :module => :media_gallery})

        SystemConfiguration::Variable.first_or_create({name: 'media.use_server_name_folder'},
                                                      {value: 'false',
                                                       description: 'Indica si usa server name como folder para almacenar las imágenes',
                                                       module: :media_gallery})

        SystemConfiguration::Variable.first_or_create({name: 'media.public_folder_root'},
                                                      {value: '',
                                                       description: 'Indica el path donde se crea la estructura para almacenar las imágenes',
                                                       module: :media_gallery})

        SystemConfiguration::Variable.first_or_create({:name => 'photo_media_accept'}, 
          {:value => 'image/jpeg,image/gif,image/png,image/jpeg', 
           :description => 'Formatos de imágenes aceptados', 
           :module => :media_gallery})
                                                      
        SystemConfiguration::Variable.first_or_create({:name => 'photo_max_size'}, 
          {:value => 1000000, 
          :description => 'Máximo tamaño de la fotografía (en bytes)', 
          :module => :media_gallery})

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
                                  :link_route => "/admin/media/album",
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
    
      routes = [{:path => '/admin/media',
                 :parent_path => '/admin',
                 :regular_expression => /^\/admin\/media/,
                 :title => 'Medios',
                 :description => 'Gestión de medios',
                 :fit => 1,
                 :module => :media_gallery}, 
                {:path => '/admin/media/config',
                 :parent_path => '/admin/media',
                 :regular_expression => /^\/admin\/media\/config/,
                 :title => 'Configuración',
                 :description => 'Configuración medios',
                 :fit => 1,
                 :module => :media_gallery},                                 
                {:path => '/admin/media/album',
                 :parent_path => '/admin/media',
                 :regular_expression => /^\/admin\/media\/album/,
                 :title => 'Albums',
                 :description => 'The albums admin tools to create and modify media albums',
                 :fit => 1,
                 :module => :media_gallery},                 
                {:path => '/admin/media/photo/:album_name',
                 :parent_path => '/admin/media/album',
                 :regular_expression => /^\/admin\/media\/photo\/.+/,
                 :title => 'Photos',
                 :description => 'It manages the album\'s photos. Used to upload and edit the album\'s photos.',
                 :fit => 1,
                 :module => :media_gallery},
                {:path => '/gallery/:album_name',
                 :regular_expression => /^\/photo_gallery\/.+/,
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
      aspects << ::Plugins::Aspect.new(:photo, app.t.aspect.photo, FieldSet::Photo, PhotoAspectDelegate.new,
                                       [Plugins::AspectConfigurationAttribute.new(:album_name, 'album name', 'photos'),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_width, 'photo width', 640),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_height, 'photo height', 480),
                                        Plugins::AspectConfigurationAttribute.new(:media_accept, 'media accept', 'image/jpeg,image/gif,image/png,image/jpeg'),
                                        Plugins::AspectConfigurationAttribute.new(:max_size, 'max size', 3000000)])

      # album (galley) aspect
      aspects << ::Plugins::Aspect.new(:album, app.t.aspect.gallery, FieldSet::Album, GalleryAspectDelegate.new,
                                       [Plugins::AspectConfigurationAttribute.new(:album_prefix, 'album prefix', 'ysd_'),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_width, 'photo width', 640),
                                        Plugins::AspectConfigurationAttribute.new(:album_photo_height, 'photo height', 480),
                                        Plugins::AspectConfigurationAttribute.new(:media_accept, 'media accept', 'image/jpeg,image/gif,image/png,image/jpeg'),
                                        Plugins::AspectConfigurationAttribute.new(:max_size, 'max size', 1000000),
                                        Plugins::AspectConfigurationAttribute.new(:render, 'render', 'album')])
                                        
      return aspects
       
    end  
  
    #
    # ---------- Path prefixes to be ignored ----------
    #

    #
    # Ignore the following path prefixes in language processor
    #
    def ignore_path_prefix_language(context={})
      %w(/media/photo)
    end

    #
    # Ignore the following path prefix in cms
    #
    def ignore_path_prefix_cms(context={})
      %w(/media/photo)
    end

  end #Media Extension
end #Social