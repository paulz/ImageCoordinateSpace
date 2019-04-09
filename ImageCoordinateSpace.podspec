Pod::Spec.new do |s|
    s.swift_version       = '5.0'
    s.cocoapods_version   = '>= 1.5.0'
    s.name                = 'ImageCoordinateSpace'
    s.version             = '1.1'
    s.summary             = 'Convert image coordinates to image view depending on content mode'
    s.description         = <<-DESC
    Convert CGPoint and CGRect between UIImage and UIImageView coordinates respecting UIViewContentMode and using UICoordinateSpace
    DESC
    s.homepage            = 'https://github.com/paulz/ImageCoordinateSpace'
    s.screenshot          = 'https://raw.githubusercontent.com/paulz/ImageCoordinateSpace/master/Example/demo.gif'
    s.license             = 'MIT'
    s.author              = { 'Paul Zabelin' => 'https://github.com/paulz' }
    s.source              = {   :git => 'https://github.com/paulz/ImageCoordinateSpace.git',
                                :tag => s.version.to_s
    }
    s.social_media_url    = 'https://twitter.com/iospaulz'
    s.platform            = :ios, '10.0'
    s.requires_arc        = true
    s.source_files        = 'ImageCoordinateSpace/**/*.{h,swift}'
    s.frameworks          = 'UIKit'
    s.test_spec do |test|
        test.source_files   = 'Unit Tests/**/*.{h,swift}'
        test.dependencies   = {
            'Quick' => '~> 2.0.0',
            'Nimble' => '~> 8.0.1'
        }
        test.requires_app_host = false
    end
end
