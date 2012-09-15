Gem::Specification.new do |s|
  s.name    = "ysd_plugin_media_gallery"
  s.version = "0.1"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-05-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*'] 
  s.description = "Media gallery integration"
  s.summary = "Media gallery integration"
  
  s.add_runtime_dependency "json"
  
  s.add_runtime_dependency "ysd_plugin_site"        # Site builder
  s.add_runtime_dependency "ysd_md_photo_gallery"   # The model
  s.add_runtime_dependency "ysd_core_themes"        # Serving static content  
  s.add_runtime_dependency "ysd_core_plugins"  
  
end