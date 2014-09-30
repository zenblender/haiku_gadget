require File.expand_path('word_template.rb', File.dirname(__FILE__))
require File.expand_path('dictionary.rb', File.dirname(__FILE__))

module HaikuGadget

  class HaikuTemplate

    attr_reader :template_matrix

    COMMON_LINES = [
      [
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb, 1, :any, 1),
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:mass_noun, 1)
      ], [
        WordTemplate.new(:adverb, 2),
        WordTemplate.new(:verb, 1, :plural),
        WordTemplate.new(:adjective, 0, :plural),
        WordTemplate.new(:noun, 1, :plural)
      ], [
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:adjective, 0, :common),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:to_be, 1, :singular),
        WordTemplate.new(:adjective, 1, :any)
      ], [
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb, 1, :any, 1),
        WordTemplate.new(:determiner, 0, :any, 2),
        WordTemplate.new(:noun, 1, :any, 2)
      ], [
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.custom('of', 1),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:verb_self, 1, :any, 1)
      ], [
        WordTemplate.custom(%w(i we they), 1),
        WordTemplate.new(:verb, 1, :plural),
        WordTemplate.new(:determiner, 0, :any, 2),
        WordTemplate.new(:adjective, 0, :any, 2),
        WordTemplate.new(:noun, 1, :any, 2),
        WordTemplate.new(:adverb)
      ]
    ]

    MIDDLE_LINES = [
      [
        WordTemplate.new(:transition_join),
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb_self, 1, :any, 1),
        WordTemplate.new(:adverb)
      ]
    ]

    BOTTOM_LINES = [
      [
        WordTemplate.new(:transition_join),
        WordTemplate.new(:adjective, 0, :plural, 1),
        WordTemplate.new(:noun, 1, :plural, 1),
        WordTemplate.new(:verb_self, 1, :plural, 1)
      ]
    ]

    ALL_TOP_LINES = [
      COMMON_LINES
    ].flatten(1)

    ALL_MIDDLE_LINES = [
      COMMON_LINES,
      MIDDLE_LINES
    ].flatten(1)

    ALL_BOTTOM_LINES = [
      COMMON_LINES,
      BOTTOM_LINES
    ].flatten(1)

    def initialize(template_matrix = nil)
      # generate a template_matrix randomly if one was not provided
      if template_matrix.nil?
        template_matrix = [
          HaikuTemplate.random_template(ALL_TOP_LINES),
          HaikuTemplate.random_template(ALL_MIDDLE_LINES),
          HaikuTemplate.random_template(ALL_BOTTOM_LINES)
        ]
      end
      # clone the two-dimensional array (so syllable counts can be changed)
      @template_matrix = template_matrix.map { |tm| tm.map { |wt| wt.clone } }
      complete_template
    end

    def generate
      lines = []
      @template_matrix.each do |word_templates|
        words = HaikuTemplate.real_words_from_templates word_templates
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
        @template_matrix.each do |word_templates|
          obj_pluralities = []
          word_templates.each do |word_template|
            if word_template.plurality == :any
              # need to pick a plurality for this word
              if word_template.obj_num > 0
                # this word is referencing an object, and its plurality can be randomized
                unless obj_pluralities[word_template.obj_num]
                  # this word's plurality has not already been determined via another word on this line
                  obj_pluralities[word_template.obj_num] = [:singular, :plural].sample
                end
                word_template.plurality = obj_pluralities[word_template.obj_num]
              else
                word_template.plurality = [:singular, :plural].sample
              end
            end
          end
        end
      end

      def complete_template_syllables
        syllables = [5, 7, 5]
        @template_matrix.each_index do |i|
          while HaikuTemplate.row_syllables(@template_matrix[i]) < syllables[i]
            increased_syllable_index = HaikuTemplate.increase_row_syllable(@template_matrix[i])
            break if increased_syllable_index.nil?
          end
        end
      end

      def self.real_words_from_templates(word_templates)
        words = []
        word_templates.each do |word_template|
          if word_template.syllables > 0
            word = word_template.word_type.get_word(
              word_template.syllables,
              word_template.plurality
            )
            words << word
          end
        end
        HaikuTemplate.convert_a_to_an words
        words
      end

      # where necessary, convert 'a' to 'an'
      def self.convert_a_to_an(words)
        words.each_index do |i|
          if words[i] == 'a' && (i < (words.length - 1)) && %w(a e i o u).include?(words[i + 1].slice(0))
            # current word is 'a', there are more words after this one, and the next one starts with a, e, i, o or u
            words[i] = 'an'
          end
        end
      end

      def self.row_syllables(word_templates)
        word_templates.map { |w| w.syllables }.inject(:+)
      end

      def self.increase_row_syllable(word_templates)
        valid_word_indices = HaikuTemplate.get_valid_word_indices word_templates

        increase_syllable_index = nil
        loop do
          increase_syllable_index = HaikuTemplate.increased_row_syllable_index(word_templates, valid_word_indices)
          break if increase_syllable_index || valid_word_indices.length == 0
        end
        if increase_syllable_index
          word_templates[increase_syllable_index].syllables += 1
          increase_syllable_index
        else
          nil
        end
      end

      def self.get_valid_word_indices(word_templates)
        out = []
        word_templates.each_index do |i|
          out << i unless word_templates[i].word_type.base_symbol == :custom
        end
        out
      end

      # returns the word index where another syllable can be added (and where dictionary words are available)
      def self.increased_row_syllable_index(word_templates, valid_word_indices)
        if valid_word_indices.length > 0
          word_index = valid_word_indices.sample
          if word_templates[word_index].word_type.words?(
            word_templates[word_index].syllables + 1,
            word_templates[word_index].plurality
          )
            word_index
          else
            # dictionary has no words of this type, remove this index so it isn't checked in the future
            valid_word_indices.delete word_index
            nil
          end
        end
      end

      def self.random_template(templates)
        template_or_array = templates.sample
        if template_or_array[0].is_a? Array
          # if NESTED object is an array, recurse
          HaikuTemplate.random_template template_or_array
        else
          template_or_array
        end
      end

  end

end