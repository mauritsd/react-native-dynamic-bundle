
Pod::Spec.new do |s|
  s.name         = "RNDynamicBundle"
  s.version      = "0.2.0"
  s.summary      = "RNDynamicBundle"
  s.description  = <<-DESC
                  RNDynamicBundle
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  s.author       = { "author" => "mauritsdijkstra@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/mauritsd/react-native-dynamic-bundle.git", :tag => "master" }
  s.source_files = "RNDynamicBundle/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
