require File.expand_path('lib/haiku_gadget.rb', File.dirname(__FILE__))

1000.times do
#  puts HaikuGadget.haiku "\n"
  puts HaikuGadget.top_line
  puts HaikuGadget.middle_line
  puts HaikuGadget.bottom_line
  puts ''
end
