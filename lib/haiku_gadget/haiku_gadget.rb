require File.expand_path('haiku_template.rb', File.dirname(__FILE__))

module HaikuGadget

  # returns a haiku as either a single string or an array of strings, based on whether a delimiter was provided
  def self.haiku(delim = nil, haiku_template = nil)
    if delim.nil?
      # no delimiter, return array
      haiku_lines haiku_template
    else
      # use delimiter and return a single string
      haiku_string delim, haiku_template
    end
  end

  # return a single string where the lines are separated by the provided delimiter
  def self.haiku_string(delim, haiku_template)
    haiku_lines(haiku_template).join delim
  end

  # return haiku as an array of lines (strings)
  def self.haiku_lines(haiku_template)
    if haiku_template.nil?
      HaikuTemplate.new.generate
    else
      haiku_template.generate
    end
  end

  def self.top_line(word_templates = nil)
    HaikuGadget.random_line(0, word_templates)
  end

  def self.middle_line(word_templates = nil)
    HaikuGadget.random_line(1, word_templates)
  end

  def self.bottom_line(word_templates = nil)
    HaikuGadget.random_line(2, word_templates)
  end

  # return just a single random line
  def self.random_line(row_index, word_templates = nil)
    fail "invalid row_index: #{row_index.to_s}" unless (0..2).include?(row_index)
    if word_templates.nil?
      # get a random template defined for the current row
      word_templates = HaikuTemplate.new.template_matrix[row_index]
    end
    # generate a HaikuTemplate object that only contains a single line with the desired template
    haiku_template = HaikuTemplate.new [word_templates]
    haiku_template.generate[0]
  end

end