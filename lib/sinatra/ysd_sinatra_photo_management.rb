require 'ui/ysd_ui_fieldset_render'
module Sinatra
  module YSD
    module PhotoManagement
   
      def self.registered(app)

        #
        # Photo management page
        #
        app.get "/photo-management/:album_name" do
          
          if media_album = Media::Album.get(params[:album_name])          

            locals = {:photo_album => media_album.name, 
                      :photo_width => media_album.width, 
                      :photo_height => media_album.height,
                      :photo_accept => SystemConfiguration::Variable.get_value('photo_media_accept'),
                      :photo_max_size => SystemConfiguration::Variable.get_value('photo_max_size').to_i}
    
            renderer = UI::FieldSetRender.new('photo', self)      
            photo_form_extension = renderer.render('formextension', 'em', locals)

            load_page('photo_management', {:locals => {:album => media_album, :photo_form_extension => photo_form_extension}})
          
          else
            status 404
          end
          
        end
             
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     