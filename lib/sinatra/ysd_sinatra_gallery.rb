require 'ysd_md_photo_gallery' unless defined?Media::Album

module Sinatra
  module YSD
    #
    # Sinatra extension to Manage a PhotoGallery
    #
    module PhotoGallery
   
      def self.registered(app)
                          
        #
        # Shows an album
        #
        app.get "/media/album/:album_id" do
          
          if media_album = Media::Album.get(params[:album_id])   
            options = {}
            if media_album
              options.store(:width, media_album.width)
              options.store(:height, media_album.height)
            end
            load_page(:album, {:locals => {:media_album => media_album, :options=> options}})
          else
            status 404
          end


        end
        
        # 
        # Shows a photo
        #
        ["/media/photo/:photo_id",
         "/media/photo/:photo_id/:size"].each do |path|
        
          app.get path do
                    
            # Get the photo        
            if photo = Media::Photo.get(params[:photo_id])
              photo_url = nil                        
              case params[:size]            
                when 'tiny'                 
                  photo_url = photo.photo_url_tiny                
                when 'small'    
                  photo_url = photo.photo_url_small              
                when 'medium'                
                  photo_url = photo.photo_url_medium                          
              end
              photo_url ||= photo.photo_url_full                    
              redirect (photo_url) 
            else
              status 404 # Not found
            end        
          
          end
        
        end
      
    
        #
        # Serves static content from the extension
        #
        app.get "/photo_gallery/*" do
            
           serve_static_resource(request.path_info.gsub(/^\/photo_gallery/,''), 
             File.join(File.dirname(__FILE__), '..', '..', 'static'), 'photo_gallery')
            
        end        
    
      end # registered  
          
    end # PhotoGallery
  end # YSD
end # Social