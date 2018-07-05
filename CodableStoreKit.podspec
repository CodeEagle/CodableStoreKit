Pod::Spec.new do |s|
    s.name                      = "CodableStoreKit"
    s.version                   = "0.0.1"
    s.summary                   = "Lightweight Codable Persistence Framework for iOS, macOS, watchOS and tvOS"
    s.homepage                  = "https://github.com/SvenTiigi/CodableStoreKit"
    s.social_media_url          = 'http://twitter.com/SvenTiigi'
    s.license                   = 'MIT'
    s.author                    = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source                    = { :git => "https://github.com/SvenTiigi/CodableStoreKit.git", :tag => s.version.to_s }
    s.ios.deployment_target     = "10.0"
    s.osx.deployment_target     = "10.12"
    s.watchos.deployment_target = "3.0"
    s.tvos.deployment_target    = "10.0"
    s.source_files              = 'Sources/**/*'
    s.frameworks                = 'Foundation', 'UIKit'
end
