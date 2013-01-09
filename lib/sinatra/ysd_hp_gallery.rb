module Sinatra
  #
  # PhotoGallery helpers
  #
  module PhotoGallery
    
    # ========= BUILDING THE GUI ============================
    
    #
    # Shows an album
    #
    # @param [String] album_name
    # @param [Symbol] display used to show the album
    #
    def album(album_name, display=:album, options={})
    
      media_album = Media::Album.get(album_name)

      locals = {}
          
      if media_album
        locals.store(:width, media_album.width)
        locals.store(:height, media_album.height)
      end

      partial(display, :locals => {:media_album => media_album, :options => options.merge(locals)})

    end
    
    #
    # Shows the component to load a photo (to integrate photo uploads)
    #
    def upload_photo(options={})
      partial :photo_selector, options
    end
                   
  end #PhotoGallery
end #Sinatra