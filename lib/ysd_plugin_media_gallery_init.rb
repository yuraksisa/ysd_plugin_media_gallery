require 'ysd-plugins' unless defined?Plugins::Plugin
require 'ysd_plugin_integration_extension'

Plugins::SinatraAppPlugin.register :media_gallery do

   name=        'media_gallery'
   author=      'yurak sisa'
   description= 'Integrate the media gallery application'
   version=     '0.1'
   sinatra_extension Sinatra::YSD::PhotoGallery
   sinatra_extension Sinatra::YSD::AlbumManagement
   sinatra_extension Sinatra::YSD::AlbumManagementRESTApi
   sinatra_extension Sinatra::YSD::PhotoManagement
   sinatra_extension Sinatra::YSD::PhotoManagementRESTApi
   sinatra_helper    Sinatra::PhotoGallery
   hooker            Huasi::MediaGalleryExtension
  
end