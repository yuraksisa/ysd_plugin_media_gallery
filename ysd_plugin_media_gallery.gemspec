Gem::Specification.new do |s|
  s.name    = "ysd_plugin_media_gallery"
  s.version = "0.1.53"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-05-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*'] 
  s.description = "Media gallery integration"
  s.summary = "Media gallery integration"
  
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "uuid"
  s.add_runtime_dependency "tilt"        

  s.add_runtime_dependency "ysd_yito_core"          # Yito core library
  s.add_runtime_dependency "ysd_yito_js"            # Yito JS library
  s.add_runtime_dependency "ysd_plugin_integration" # Integration
  
  s.add_runtime_dependency "ysd_core_plugins"
  s.add_runtime_dependency "ysd_core_themes"        # Serves assets
  
  s.add_runtime_dependency "ysd_md_photo_gallery"   # Media model
  s.add_runtime_dependency "ysd_md_configuration"   # Configuration model
 
end