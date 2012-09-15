module Sinatra
  module YSD
    module PhotoManagementRESTApi
   
      def self.registered(app)
        
        #
        # Retrive the photos of an album (GET)
        #
        app.get "/photos/:album_name" do
          data=Media::Album.all
  
          # Prepare the result
          content_type :json
          data.to_json
        end
        
        #
        # Retrieve the photos of an album (POST)
        #
        ["/photos/:album_name","/photos/:album_name/page/:page"].each do |path|
          app.post path do
          
            media_album=Media::Album.get(params[:album_name])
            
            # Synchronizes the album information
            data = if media_album and media_album.adapted_album
                     media_album.adapted_album.photos 
                   else
                     []
                   end
            
            total = data.length       
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Create a new photo
        #
        app.post "/photo" do
        
          # It redirects to the photo uploaded
          status, header, body = call! env.merge("PATH_INFO" => "/photo_gallery/photo")    
        
        end
        
        #
        # Updates a photo
        #
        app.put "/photo" do
        
          # It redirects to the photo uploaded
          status, header, body = call! env.merge("PATH_INFO" => "/photo_gallery/photo")    
        
        end
        
        #
        # Deletes a photo
        #
        app.delete "/photo" do
        
        end
     
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     