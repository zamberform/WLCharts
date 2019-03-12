Pod::Spec.new do |s|
  s.name             = 'WLCharts'
  s.version          = '1.0.0'
  s.summary          = 'A Collection of Charts'

  s.description      = <<-DESC
The Collection of Charts,
I created LineChart, PieChart, CircleChart, RadarChart, ScatterChart.
                       DESC

  s.homepage         = 'https://github.com/brightzamber/WLCharts'
  s.screenshots     = 'https://github.com/brightzamber/WLCharts/screen/WLCharts.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brightzamber' => 'brightzamber@gmail.com' }
  s.source           = { :git => 'https://github.com/brightzamber/WLCharts.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WLCharts/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.swift_version = '4.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
