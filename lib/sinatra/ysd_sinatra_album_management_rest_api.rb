require 'json' unless defined?JSON
require 'uri' unless defined?URI
require 'ysd_md_photo_gallery' unless defined?Media::Album

module Sinatra
  module YSD
    #
    # Album management REST API
    #
    module AlbumManagementRESTApi
   
      def self.registered(app)
        
        #
        # Retrieve the album displays templates
        #
        app.get "/api/displays/album" do
          
          resources = find_resources(/^_album.+\.erb/).map do |item| 
            {:id => (value=item[1..-5]), :description => value}
          end

          content_type :json
          resoureces.to_json

        end

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
          
          request.body.rewind
          album_request = JSON.parse(URI.unescape(request.body.read))

          the_album = Media::Album.create(album_request) 
          
          status 200
          content_type :json
          the_album.to_json          
        
        end
        
        #
        # Updates a album
        #
        app.put "/album" do
        
          request.body.rewind
          album_request = JSON.parse(URI.unescape(request.body.read))
                
          the_album = Media::Album.get(album_request['name'])
          the_album.attributes=(album_request)
          the_album.save
                   
          status 200
          content_type :json
          the_album.to_json
        
        
        end
        
        #
        # Deletes an album
        #
        app.delete "/album" do

          request.body.rewind
          album_request = JSON.parse(URI.unescape(request.body.read))
          
          if the_album = Media::Album.get(album_request['name'])
            the_album.destroy
          end
          
          status 200
          content_type :json
          true.to_json 
        
        end
      
      end
    
    end #AlbumManagementRESTAPi
  end #YSD
end #Sinatra