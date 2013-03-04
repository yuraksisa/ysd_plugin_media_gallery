module Sinatra
  module YSD
    module AlbumManagement
   
      def self.registered(app)
            
        # Add the local folders to the views and translations     
        app.settings.views = Array(app.settings.views).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))
        
        #
        # Album management page
        #
        app.get "/album-management" do
          load_page :album_management
        end
              
      end
    
    end #AlbumManagement
  end #YSD
end #Sinatra