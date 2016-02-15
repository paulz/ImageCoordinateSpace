Pod::Spec.new do |s|
    s.name                = 'ImageCoordinateSpace'
    s.version             = '0.2.0'
    s.summary             = 'Convert image coordinates to image view depending on content mode'
    s.description         = <<-DESC
    Convert CGPoint and CGRect between UIImage and UIImageView coordinates respecting UIViewContentMode and using UICoordinateSpace
    DESC
    s.homepage            = "https://github.com/paulz/ImageCoordinateSpace"
    # s.screenshots       = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license             = 'MIT'
    s.author              = { "Paul Zabelin" => "https://github.com/paulz" }
    s.source              = { :git => "https://github.com/paulz/ImageCoordinateSpace.git", :tag => s.version.to_s }
    s.social_media_url    = 'https://twitter.com/iospaulz'
    s.platform            = :ios, '8.0'
    s.requires_arc        = true
    s.source_files        = 'ImageCoordinateSpace/**/*'
    s.resource_bundles    = {
        'ImageCoordinateSpace' => ['Pod/Assets/*.png']
    }
    s.frameworks = 'UIKit'
end
