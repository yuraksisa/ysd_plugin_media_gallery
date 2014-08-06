require 'ysd_md_photo_gallery' unless defined?Media::Album

module Sinatra
  module YSD
    #
    # REST API to manage album's photos
    #
    module PhotoManagementRESTApi
   
      def self.registered(app)
        
        #
        # Retrive the photos of an album (GET)
        #
        app.get "/photos/:album_name" do
          
          if media_album = Media::Album.get(params[:album_name])
            content_type :json
            media_album.photos.nil? ? [].to_json : media_album.photos.to_json
          else
            status 404
          end

        end
        
        #
        # Retrieve the photos of an album (POST)
        #
        ["/photos/:album_name","/photos/:album_name/page/:page"].each do |path|
          app.post path do
          
            media_album=Media::Album.get(params[:album_name])
            
            data = if media_album and media_album.adapted_album
                     media_album.photos 
                   else
                     []
                   end
            
            total = data.length       
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        app.get "/photo/:id" do

          if photo = Media::Photo.get(params[:id])
            content_type :json
            photo.to_json
          else
            status 404
          end

        end

        #
        # Create a new photo
        #
        app.post "/photo" do
        
          status, header, body = call! env.merge("PATH_INFO" => "/photo_gallery/photo")    
        
        end
        
        #
        # Updates a photo
        #
        app.put "/photo" do
        
          status, header, body = call! env.merge("PATH_INFO" => "/photo_gallery/photo")    
        
        end
        
        #
        # Deletes a photo
        #
        app.delete "/photo/:id" do
        
          if photo = Media::Photo.get(params[:id])
            photo.destroy
            content_type :json
            true.to_json
          else
            content_type :json
            true.to_json
          end  



        end
     
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     