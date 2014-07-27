desc "Run the test suite"

task :test do
  build = "xcodebuild \
    -workspace PopTipDemo/PopTipDemo.xcworkspace \
    -scheme PopTipDemo \
    -sdk iphonesimulator -destination 'name=iPhone Retina (4-inch)'"
  system "#{build} test | xcpretty --test --color"  
end

task :default => :test


