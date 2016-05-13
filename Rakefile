desc "Run the test suite"

task :test do
  build = "xcodebuild \
    -workspace PopTipDemo/PopTipDemo.xcworkspace \
    -scheme PopTipDemo \
    -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6s,OS=9.3'"
  system "#{build} test | xcpretty --test --color"  
end

task :default => :test


