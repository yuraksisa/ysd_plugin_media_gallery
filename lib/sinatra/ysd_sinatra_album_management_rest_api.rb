module Sinatra
  module YSD
    module AlbumManagementRESTApi
   
      def self.registered(app)
                    
        #
        # Retrive all albums (GET)
        #
        app.get "/albums" do
          data=Media::Album.all
  
          # Prepare the result
          content_type :json
          data.to_json
        end
        
        #
        # Retrieve albums (POST)
        #
        ["/albums","/albums/page/:page"].each do |path|
          app.post path do
          
            data=Media::Album.all
            
            # Synchronizes the album information
            data.each do |album|            
             album.synchronize_data
            end
            
            begin # Count does not work for all adapters
              total=Media::Album.count
            rescue
              total=Media::Album.all.length
            end
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Create a new album
        #
        app.post "/album" do
        
          puts "Creating album"
          
          request.body.rewind
          album_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new album
          the_album = Media::Album.create(album_request) 
          
          puts "created album : #{the_album}"
          
          # Return          
          status 200
          content_type :json
          the_album.to_json          
        
        end
        
        #
        # Updates a album
        #
        app.put "/album" do
        
          puts "Updating album"
        
          request.body.rewind
          album_request = JSON.parse(URI.unescape(request.body.read))
          
          # Updates the album          
          the_album = Media::Album.get(album_request['name'])
          the_album.attributes=(album_request)
          the_album.save
          
          puts "updated album : #{the_album}"
                   
          # Return          
          status 200
          content_type :json
          the_album.to_json
        
        
        end
        
        #
        # Deletes an album
        #
        app.delete "/album" do
        
        end
      
      end
    
    end #AlbumManagementRESTAPi
  end #YSD
end #Sinatra