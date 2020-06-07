desc "Run the test suite"

task :test do
  build = "xcodebuild \
    -workspace 'Demo/PopTip\ Demo.xcworkspace' \
    -scheme 'PopTip\ Demo' \
    -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8,OS=13.5'"
  system "#{build} test | xcpretty --test --color"
end

task :default => :test
