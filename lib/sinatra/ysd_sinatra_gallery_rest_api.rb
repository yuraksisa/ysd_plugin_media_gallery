require 'uuid'
module Sinatra
  module YSD
    #
    # REST API to Manage a PhotoGallery
    #
    # Configuration
    # -------------
    #  
    #  - default_album: The album where store the image
    #  - default_photo_width: Photo width (resized)
    #  - default_photo_height: Photo height (resized)
    #
    # 
    # Resources:
    # ----------
    # http://www.w3.org/TR/html40/interact/forms.html
    # http://www.cs.tut.fi/~jkorpela/forms/file.html
    # http://www.matlus.com/html5-file-upload-with-progress/
    # http://dev.w3.org/2006/webapi/FileAPI/    
    #
    module PhotoGalleryRESTApi
   
      def self.registered(app)

        app.set :default_album, 'photos'
        app.set :default_photo_width, 480
        app.set :default_photo_height, 480
                 
        #
        # Upload a photo
        #
        # The action responses with the uploaded resource
        #
        app.post "/photo_gallery/photo" do
 
          album_name = params['photo_album'] 

          if album_name.empty?
            album_prefix = params['photo_album_prefix']            
            if album_prefix.empty?
              album_name = settings.default_album
            else
              album_name = album_prefix
              album_name << UUID.generator.generate(:compact)
            end 
          end
          
          album_data = {}
          album_data.store(:width, params['photo_width'].to_i || settings.default_photo_width.to_i)
          album_data.store(:height, params['photo_height'].to_i || settings.default_photo_height.to_i)
           
          photo_data = {}
          photo_data.store(:photo_id, params['photo_id']) if (params['photo_id'] and not params['photo_id'].empty?)   
          photo_data.store(:photo_name, if params['photo_name'] and not params['photo_name'].empty?
                                          params['photo_name'] 
                                        else
                                          params['photo_file'][:filename]
                                        end)
          photo_data.store(:photo_description,if params['photo_description'] and not params['photo_description'].empty? 
                                                params['photo_description'] 
                                              else
                                                params['photo_file'][:filename]
                                              end)  
          
          photo_file = params['photo_file'][:tempfile]
          
          # Get the album   
          media_album = Media::Album.first_or_create({:name => album_name}, album_data) 
                    
          # Update the photo
          photo=media_album.add_or_update_photo(photo_data, photo_file)
                               
          status 200
          body photo.to_json
          
        end        
        
        #
        # Deletes a photo
        #
        app.delete "/photo_gallery/:album_name/photo/:photo_id" do

          if media_album = Media::Album.get(params[:album_name])
            media_album.delete_photo(params[:photo_id])
            status 400
            media_album.to_json
          else
            status 404
          end

        end
    
      end # registered  
          
    end # PhotoGalleryRESTApi
  end # YSD
end # Sinatra