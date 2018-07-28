require 'ysd_md_photo_gallery' unless defined?Media::Album

module Sinatra
  module YSD
    #
    # REST API to manage album's photos
    #
    module PhotoManagementRESTApi
   
      def self.registered(app)

        app.set :default_album, 'photos'
        app.set :default_photo_width, 480
        app.set :default_photo_height, 480

        #
        # Retrive the photos of an album (GET)
        #
        app.get "/api/photos/:album_name" do
          
          if media_album = Media::Album.get(params[:album_name])
            content_type :json
            media_album.photos.nil? ? [].to_json : media_album.photos.to_json
          else
            status 404
          end

        end
        
        #
        # Retrieve the photos of an album (POST)
        #
        ["/api/photos/:album_name","/api/photos/:album_name/page/:page"].each do |path|
          app.post path do
          
            media_album=Media::Album.get(params[:album_name])
            
            data = if media_album 
                     media_album.photos 
                   else
                     []
                   end
            
            total = data.length       
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end

        #
        # Retrive a photo by its id
        #
        app.get "/api/photo/:id" do

          if photo = Media::Photo.get(params[:id])
            content_type :json
            photo.to_json
          else
            status 404
          end

        end

        #
        # Upload a photo (creates or updates)
        #
        # POST a form with the following fields in order to upload a photo
        #
        #   - photo_file : The photo file *REQUIRED
        #
        #   - photo_album : The album id if the photo belongs to an existing album
        #   - photo_id : The photo id if the photo already exists
        #   - photo_name : The photo name
        #   - photo_description : The photo description (for IMG ALT attribute)
        #
        app.post "/api/photo" do

          album_id = params['photo_album'].to_i
          album_data = {}
          album_data.store(:width, params['photo_width'].to_i || settings.default_photo_width.to_i)
          album_data.store(:height, params['photo_height'].to_i || settings.default_photo_height.to_i)
          if params.has_key?('photo_album_prefix') && !params['photo_album_prefix'].nil? &&
             !params['photo_album_prefix'].empty?
            album_data.store(:album_context, params['photo_album_prefix'])
            album_data.store(:root, params['photo_album_prefix'])
          end

          photo_data = {}
          photo_data.store(:photo_id, params['photo_id'].to_i) if (params['photo_id'] and not params['photo_id'].empty?)
          photo_data.store(:photo_name, if params['photo_name'] and not params['photo_name'].empty?
                                          params['photo_name']
                                        else
                                          params['photo_file'][:filename]
                                        end)
          photo_data.store(:photo_description,if params['photo_description'] and not params['photo_description'].empty?
                                                params['photo_description']
                                              else
                                                params['photo_file'][:filename]
                                              end)

          photo_file = params['photo_file'][:tempfile]

          # Find/create the album
          media_album = if album_id == 0
                          Media::Album.create(album_data)
                        else
                          Media::Album.first_or_create({:id => album_id}, album_data)
                        end

          # Add the photo to the album
          photo=media_album.add_or_update_photo(photo_data, photo_file, params['photo_file'][:filename])

          status 200
          body photo.to_json

        end

        #
        # Uploads a photo (create or update) and updates the associated variable
        #
        # POST a form with the following fields in order to upload a photo
        #
        #   - name: The variable name *REQUIRED
        #   - photo_file : The photo file *REQUIRED
        #
        #   - photo_album : The album id if the photo belongs to an existing album
        #   - photo_id : The photo id if the photo already exists
        #   - photo_name : The photo name
        #   - photo_description : The photo description (for IMG ALT attribute)
        #
        app.post "/api/photo-variable" do

          variable_name = params['name']

          album_id = params['photo_album'].to_i

          album_data = {}
          album_data.store(:width, params['photo_width'].to_i || settings.default_photo_width.to_i)
          album_data.store(:height, params['photo_height'].to_i || settings.default_photo_height.to_i)

          photo_data = {}
          photo_data.store(:photo_id, params['photo_id'].to_i) if (params['photo_id'] and not params['photo_id'].empty?)
          photo_data.store(:photo_name, if params['photo_name'] and not params['photo_name'].empty?
                                          params['photo_name']
                                        else
                                          params['photo_file'][:filename]
                                        end)
          photo_data.store(:photo_description,if params['photo_description'] and not params['photo_description'].empty?
                                                params['photo_description']
                                              else
                                                params['photo_file'][:filename]
                                              end)

          photo_file = params['photo_file'][:tempfile]


          Media::Album.transaction do

            # Find/create the album
            media_album = if album_id == 0
                            Media::Album.create(album_data)
                          else
                            Media::Album.first_or_create({:id => album_id}, album_data)
                          end

            # Add the photo to the album
            photo=media_album.add_or_update_photo(photo_data, photo_file, params['photo_file'][:filename])

            # Updates the variable
            SystemConfiguration::Variable.set_value(variable_name, "/media/photo/#{photo.id}")

            status 200
            body photo.to_json
          end

        end

        #
        # Updates photo attributes
        #
        app.put "/api/photo" do

          request.body.rewind
          photo_request = body_as_json(Media::Photo)

          photo = Media::Photo.get(photo_request.delete(:id))
          photo.attributes=(photo_request)
          photo.save

          status 200
          content_type :json
          photo.to_json

        end
        
        #
        # Deletes a photo
        #
        app.delete "/api/photo/:id" do
        
          if photo = Media::Photo.get(params[:id])
            photo.destroy
            content_type :json
            true.to_json
          else
            content_type :json
            true.to_json
          end  

        end
     
     end
     
   end #PhotoManagement
 end #YSD
end #Sinatra     