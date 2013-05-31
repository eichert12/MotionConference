# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'MotionConference'
  app.libs << '/usr/lib/libresolv.dylib'
  app.libs << '/usr/lib/libz.dylib'
  app.libs << '/usr/lib/libc++.dylib'

  app.frameworks += [
    'OpenGLES',
    'AVFoundation',
    'QuartzCore',
    'CFNetwork',
    'CoreVideo',
    'CoreGraphics',
    'CoreMedia',
    'AudioToolbox',
    'SystemConfiguration']

  app.vendor_project('vendor/ShowKit.framework',
                     :static,
                     :products => ['ShowKit'],
                     :headers_dir => 'Headers',
                     :force_load => false)
end
