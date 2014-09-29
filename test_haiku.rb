require File.expand_path('lib/haiku_hipster.rb', File.dirname(__FILE__))

1000.times do
#  puts HaikuHipster.haiku "\n"
  puts HaikuHipster.top_line
  puts HaikuHipster.middle_line
  puts HaikuHipster.bottom_line
  puts ''
end
