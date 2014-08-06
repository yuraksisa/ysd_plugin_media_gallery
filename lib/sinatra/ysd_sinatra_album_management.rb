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
        app.get "/admin/album/?*" do

          locals = {
                     :photo_accept => SystemConfiguration::Variable.get_value('photo_media_accept'),
                     :photo_max_size => SystemConfiguration::Variable.get_value('photo_media_accept').to_i
                   }

          load_em_page :album_management, :album, false, :locals => locals
        end
              
      end
    
    end #AlbumManagement
  end #YSD
end #Sinatra