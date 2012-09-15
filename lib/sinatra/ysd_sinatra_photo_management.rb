module Sinatra
  module YSD
    module PhotoManagement
   
      def self.registered(app)

        #
        # Photo management page
        #
        app.get "/photo-management/:album_name" do
          media_album = Media::Album.get(params[:album_name])          
          load_page 'photo_management'.to_sym, :locals => {:album => media_album, :photo_width => 640, :photo_height => 480}
        end
             
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     