require File.expand_path('dictionary.rb', File.dirname(__FILE__))
require File.expand_path('line_templates.rb', File.dirname(__FILE__))

module HaikuGadget

  class HaikuTemplate

    attr_reader :template_matrix

    def initialize(template_matrix = nil)
      # generate a template_matrix randomly if one was not provided
      if template_matrix.nil?
        template_matrix = [
          HaikuTemplate.random_template(LineTemplates::ALL_TOP_LINES),
          HaikuTemplate.random_template(LineTemplates::ALL_MIDDLE_LINES),
          HaikuTemplate.random_template(LineTemplates::ALL_BOTTOM_LINES)
        ]
      end
      # clone the two-dimensional array (so syllable counts can be changed safely)
      @template_matrix = template_matrix.map { |lt| lt.clone } 
      complete_template
    end

    def generate
      lines = []
      @template_matrix.each do |line_template|
        words = line_template.real_words
        lines << words.join(' ')
      end
      lines
    end

    private

      def complete_template
        complete_template_plurality
        complete_template_syllables
      end

      def complete_template_plurality
        @template_matrix.each do |line_template|
          line_template.complete_plurality
        end
      end

      def complete_template_syllables
        syllables = [5, 7, 5]
        @template_matrix.each_index do |i|
          @template_matrix[i].complete_syllables syllables[i]
        end
      end

      def self.random_template(templates)
        template_or_array = templates.sample
        if template_or_array.is_a? Array
          # if NESTED object is an array, recurse
          HaikuTemplate.random_template template_or_array
        else
          # current object should be of type LineTemplate
          template_or_array
        end
      end

  end

end