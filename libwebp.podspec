Pod::Spec.new do |s|
  s.name             = 'libwebp'
  s.version          = '1.3.0'
  s.summary          = 'Library to encode and decode images in WebP format.'
  s.homepage         = 'https://developers.google.com/speed/webp/'
  s.authors          = 'Google Inc.'
  s.license          = { :type => 'BSD', :file => 'COPYING' }
  s.source           = { :git => 'https://github.com/webmproject/libwebp.git', :tag => 'v' + s.version.to_s }

  s.compiler_flags = '-D_THREAD_SAFE'
  s.requires_arc = false

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.pod_target_xcconfig = {
    'USER_HEADER_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/libwebp/ ${PODS_TARGET_SRCROOT}/'
  }
  s.preserve_paths = 'src', 'sharpyuv'
  s.default_subspecs = 'webp', 'demux', 'mux'

  # webp decoding && encoding
  s.subspec 'webp' do |ss|
    ss.source_files = './libwebp/src/webp/decode.h', './libwebp/src/webp/encode.h', './libwebp/src/webp/types.h', './libwebp/src/webp/mux_types.h', './libwebp/src/webp/format_constants.h', './libwebp/src/utils/*.{h,c}', './libwebp/src/dsp/*.{h,c}', './libwebp/src/dec/*.{h,c}', './libwebp/src/enc/*.{h,c}', 'sharpyuv/*.{h,c}'
    ss.public_header_files = './libwebp/src/webp/decode.h', './libwebp/src/webp/encode.h', './libwebp/src/webp/types.h', './libwebp/src/webp/mux_types.h', './libwebp/src/webp/format_constants.h'
  end

  # animated webp decoding
  s.subspec 'demux' do |ss|
    ss.dependency 'libwebp/webp'
    ss.source_files = './libwebp/src/demux/*.{h,c}', './libwebp/src/webp/demux.h'
    ss.public_header_files = './libwebp/src/webp/demux.h'
  end

  # animated webp encoding
  s.subspec 'mux' do |ss|
    ss.dependency 'libwebp/demux'
    ss.source_files = './libwebp/src/mux/*.{h,c}', './libwebp/src/webp/mux.h'
    ss.public_header_files = './libwebp/src/webp/mux.h'
  end

  # fix #include <inttypes.h> cause 'Include of non-modular header inside framework module error'
  s.prepare_command = <<-CMD
                      sed -i.bak 's/<inttypes.h>/<stdint.h>/g' '././libwebp/src/webp/types.h'
                      CMD
end