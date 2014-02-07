module Sinatra
  module YitoExtension
    module MediaStorageManagement
       
      def self.registered(app)
                    
        #
        # Storage management page
        #        
        app.get "/admin/media-storage/?*", :allowed_usergroups => ['staff'] do
          load_page 'media_storage_management'.to_sym
        end
        
      
      end
    
    end #MenuManagement
  end #YSD
end #Sinatra