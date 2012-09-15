YSD = window.YSD || {};

YSD.photoGallery = {
  
  /********
   * Format the media url to include photos in the contents and anywhere
   *
   * @param [String] prefix
   * @param [String] photo
   * @param [String] size
   * @param [Boolean] force_reload
   *
   */	
  media_url : function(prefix, photo, size, force_reload, build_path) {
  
    if (typeof photo == 'undefined') {
      return null;	
    }
  
    the_url = null;
  
    if (photo.cache && photo.cache[size]) {
      the_url = photo.cache[size];	
    }
  
    if (typeof build_path == 'undefined') {
      build_path = false;	
    }
    
    // Builds the path to query the media system
    
    if (build_path && !url && typeof photo.path != 'undefined') {
      
      if (typeof size == 'undefined') {
        size = ''; 	
      }
      else
      {
        size = '/' + size;	
      }

      if (typeof force_reload == 'undefined') {
        force_reload = false;	
      }
    
      the_url = prefix + '/' + photo + size + (force_reload?'?'+new Date().getTime():''); 	
  	
    }
    
    return the_url;
  	
  }
	
	
}