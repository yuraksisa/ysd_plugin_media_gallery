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
        app.get "/photo_gallery/album/:album_name" do
          
          media_album = Media::Album.get(params[:album_name])   
          
          options = {}
          
          if media_album
            options.store(:width, media_album.width)
            options.store(:height, media_album.height)
          end
          
          load_page(:album, {:locals => {:media_album => media_album, :options=> options}})
        
        end
        
        # 
        # Shows a photo
        #
        ["/photo_gallery/album/:album_name/photo/:photo_id",
         "/photo_gallery/album/:album_name/photo/:photo_id/:size"].each do |path|
        
          app.get path do
          
            # Get the album by its id                
            album = PhotoCollection::Album.get_by_name(params[:album_name])
          
            # Get the photo        
            if album
          
              photo = (album.photos.select { |photo| photo.id == params[:photo_id] }).first 
              
              if photo              
                photo_url = nil                        
                case params[:size]            
                  when 'tiny'                 
                    photo_url = photo.thumbnails.first.thumbnail_url                
                  when 'small'    
                    photo_url = photo.thumbnails[1].thumbnail_url              
                  when 'medium'                
                    photo_url = photo.thumbnails.last.thumbnail_url                          
                end
          
                photo_url ||= photo.image_url                    
                redirect (photo_url) 
              else
                status 404 # Not found
              end        
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