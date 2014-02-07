module Sinatra
  module YitoExtension
    module MediaStorageManagementRESTApi
       
      def self.registered(app)
               
        #
        # Retrieve all the storages
        #
        app.get "/api/media-storages", :allowed_usergroups => ['staff'] do
          data = ::Media::Storage.all
          
          content_type :json
          data.to_json
        end
                
        #
        # Retrive storages
        #
        ["/api/media-storages","/api/media-storages/page/:page"].each do |path|
          app.post path, :allowed_usergroups => ['staff'] do
            
            data, total = ::Media::Storage.all_and_count
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Retrieve the storage adapters
        #
        app.get "/api/media-storage-adapters", :allowed_usergroups => ['staff'] do
        
          adapters = []
          adapters << { :id => 'picasa', :description => 'picasa' }
          
          status 200
          content_type :json
          body adapters.to_json
        
        end
        
        #
        # Retrieve an storage
        #
        app.get "/api/media-storage/:id", :allowed_usergroups => ['staff'] do
          
          storage = Media::Storage.get(params[:id])

          status 200
          content_type :json
          storage.to_json
        
        end
        
        #
        # Create an media storage
        #
        app.post "/api/media-storage", :allowed_usergroups => ['staff'] do
        
          request.body.rewind
          storage_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new menu
          storage = ::Media::Storage.new(storage_request)
          storage.save
          
          # Return          
          status 200
          content_type :json
          storage.to_json          
        
        end
        
        #
        # Updates a media storage
        #
        app.put "/api/media-storage", :allowed_usergroups => ['staff'] do
        
          request.body.rewind
          storage_request = JSON.parse(URI.unescape(request.body.read))
          
          # Updates the storage
          storage = ::Media::Storage.get(storage_request[:id])

          storage.attributes=(storage_request)
          storage.save
          
          # Return          
          status 200
          content_type :json
          storage.to_json
        
        
        end
        
        #
        # Deletes a media storage
        #
        app.delete "/api/media-storage", :allowed_usergroups => ['staff'] do

          request.body.rewind
          storage_request = JSON.parse(URI.unescape(request.body.read))

          # Remove the storage
          storage = ::Media::Storage.get(storage_request[:id])
          storage.destroy
          
          # Return
          status 200
          content_type :json
          true.to_json
          
        end
      
      end
    
    end #MenuManagementRESTApi
  end #YSD
end #Sinatra