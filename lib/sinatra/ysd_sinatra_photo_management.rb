module Sinatra
  module YSD
    module PhotoManagement
   
      def self.registered(app)

        #
        # Photo management page
        #
        app.get "/photo-management/:album_name" do
          
          if media_album = Media::Album.get(params[:album_name])          
            load_page 'photo_management'.to_sym, :locals => {:album => media_album}
          else
            status 404
          end
          
        end
             
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     