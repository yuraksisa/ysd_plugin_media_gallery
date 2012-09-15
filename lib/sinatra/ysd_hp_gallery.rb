module Sinatra
  #
  # PhotoGallery helpers
  #
  module PhotoGallery
    
    # ========= BUILDING THE GUI ============================
    
    # Shows an album
    #
    def album(album_name, options={})
    
      album = PhotoCollection::Album.get_by_name(album_name)
      load_page(:album, {:locals => {:album => album, :options => options}})
    
    end
    
    # Shows the component to load a photo (to integrate photo uploads)
    #
    def upload_photo(options={})
      partial :photo_selector, options
    end
    
    # Format the url media
    #
    # @param [String] prefix
    # @param [Hash] photo 
    #   :path => album/:album_name/photo/:photo_id
    #   :cache => {:tiny => url, :small => url, :medium => url, :full => url}
    # @param [String] size
    #   The format to show : tiny, small, medium
    # @param [Boolean] force_reload
    #   If the img should be reloaded
    #
    # @return [String]
    #   The media path to include in the application
    #   Or nil if there is not photo information
    #
    def media_url(prefix, photo, size=nil, force_reload=false, build_path=false)

      the_url = 
        if photo and photo[:cache] and photo[:cache][size.to_sym]
          (photo[:cache][size.to_sym].strip.length>0)?photo[:cache][size.to_sym]:nil
        else                   
          if (build_path) and (photo and photo[:path])   
            url = ["#{prefix}/#{photo[:path]}"]
            url << "/#{size}" if size
            url << "?#{Time.now.to_i}" if force_reload
            url.join()
          end
        end
     
    end    
               
  end #PhotoGallery
end #Sinatra