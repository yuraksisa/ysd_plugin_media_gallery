module Sinatra
  module YitoExtension
    module MediaStorageManagement
       
      def self.registered(app)
                    
        #
        # Storage management page
        #        
        app.get "/admin/media/storage/?*", :allowed_usergroups => ['staff'] do
          load_em_page :media_storage_management, nil, false
        end
        
      
      end
    
    end #MenuManagement
  end #YSD
end #Sinatra