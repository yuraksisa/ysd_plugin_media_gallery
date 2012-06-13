#
# Middleware functionality
#
module Sinatra
  
 module MediaGallery
    
   def self.registered(app)
      
     # Add the local folders to the views and translations     
     app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', 'i18n')))       
   
   end
   
 end #MediaGallery
end #Sinatra