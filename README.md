# Yito media gallery plugin

It's a yito plugin that implements the GUI to manage media albums.

It also defines the following helpers, that can be used in your controllers or
views:

* album(album_name, display=:album, opts={}) To render an album
* upload_photo(opts={}) To upload a photo

It also defines two aspects:

* photo
* album

## Usage

Just include the gem dependency in your Gemfile and run bundle update

```ruby
gem "ysd_plugin_media_gallery"
```

A new menu option, /album-management, will be available in the content manager 
menu.

Some new routes will be available:

* /photo_gallery/album/:album_name : It renders an album. 

Two news aspects will be available, photo and album.