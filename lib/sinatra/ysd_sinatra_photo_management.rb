require 'ui/ysd_ui_fieldset_render'
require 'ysd_md_photo_gallery' unless defined?Media::Album
require 'ysd_md_configuretion' unless defined?SystemConfiguration::Variable

module Sinatra
  module YSD
    #
    # Manages an album photos
    #
    module PhotoManagement
   
      def self.registered(app)

        app.get '/admin/media', :allowed_usergroups => ['staff'] do
          load_page(:console_media_gallery)
        end

        #
        # Media Gallery configuration
        #
        app.get '/admin/media/config', :allowed_usergroups => ['staff'] do
          locals = {}
          media_storage = SystemConfiguration::Variable.get_value('media.default_storage', nil)
          locals.store(:not_media_storage, (media_storage.nil? or media_storage.empty?) )
          locals.store(:storages, Hash[ *::Media::Storage.all.collect { |v| [v.name, v.name]}.flatten ])
          load_page(:config_media_gallery, :locals => locals)
        end

        #
        # Add a photo to an album
        #
        app.get "/admin/media/photo/new/:album_id" do
          
          if album = Media::Album.get(params[:album_id])

            locals = {:photo_album => album.id, 
                      :photo_width => album.width, 
                      :photo_height => album.height,
                      :photo_accept => SystemConfiguration::Variable.get_value('photo_media_accept'),
                      :photo_max_size => SystemConfiguration::Variable.get_value('photo_max_size').to_i}
    
            renderer = UI::FieldSetRender.new('photo', self)      
            photo_form_extension = renderer.render('formextension', 'em', locals)

            load_page('photo_management', {:locals => {:album => album,
             :photo_form_extension => photo_form_extension, :album_id => album.id, :photo_id => nil, :action => 'new'}})
          
          else
            status 404
          end
          
        end


        #
        # Update an album photo
        #
        app.get "/admin/media/photo/:photo_id" do
          
          if photo = Media::Photo.get(params[:photo_id])

            locals = {:photo_album => photo.album.id, 
                      :photo_width => photo.album.width, 
                      :photo_height => photo.album.height,
                      :photo_id => photo.id,
                      :photo_accept => SystemConfiguration::Variable.get_value('photo_media_accept'),
                      :photo_max_size => SystemConfiguration::Variable.get_value('photo_max_size').to_i}
    
            renderer = UI::FieldSetRender.new('photo', self)      
            photo_form_extension = renderer.render('formextension', 'em', locals)

            load_page('photo_management', {:locals => {:album => photo.album,
             :photo_form_extension => photo_form_extension, :album_id => photo.album.id, :photo_id => photo.id, :action => 'edit'}})
          
          else
            status 404
          end
          
        end
             
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     