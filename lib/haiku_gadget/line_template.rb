require File.expand_path('haiku_template.rb', File.dirname(__FILE__))
require File.expand_path('word_template.rb', File.dirname(__FILE__))

module HaikuGadget

  class LineTemplate

    # the relative likelyhood that a word with existing syllables is going to be
    # chosen over one that has no syllables (for example, 3 means 3 times as likely)
    EXISTING_SYLLABLES_PRIORITY = 3

    attr_reader :word_templates

    def initialize(*word_templates)
      @word_templates = word_templates.flatten
    end

    def clone
      LineTemplate.new @word_templates.map{ |wt| wt.clone }
    end

    def current_syllables
      @word_templates.map { |w| w.syllables }.inject(:+)
    end

    def get_valid_word_indices
      out = []
      @word_templates.each_index do |i|
        out << i unless @word_templates[i].word_type.base_symbol == :custom
      end
      out
    end

    def increase_row_syllable
      valid_word_indices = get_valid_word_indices

      increase_syllable_index = nil
      loop do
        increase_syllable_index = increased_row_syllable_index valid_word_indices
        break if increase_syllable_index || valid_word_indices.length == 0
      end
      if increase_syllable_index
        @word_templates[increase_syllable_index].syllables += 1
        increase_syllable_index
      else
        nil
      end
    end

    def increased_row_syllable_index(valid_word_indices)
      if valid_word_indices.length > 0
        word_index = weighted_sample_index valid_word_indices
        if @word_templates[word_index].word_type.words?(
          @word_templates[word_index].syllables + 1,
          @word_templates[word_index].plurality
        )
          word_index
        else
          # dictionary has no words of this type, remove this index so it isn't checked in the future
          valid_word_indices.delete word_index
          nil
        end
      end
    end

    def complete_syllables(required_syllables)
      while current_syllables < required_syllables
        increased_syllable_index = increase_row_syllable
        break if increased_syllable_index.nil?
      end
    end

    def complete_plurality
      obj_pluralities = []
      @word_templates.each do |word_template|
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

    def real_words
      words = []
      @word_templates.each do |word_template|
        if word_template.syllables > 0
          word = word_template.word_type.get_word(
            word_template.syllables,
            word_template.plurality
          )
          words << word
        end
      end
      LineTemplate.convert_a_to_an words
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

    private

      # give more weight to words that have >0 syllables already,
      # which reduces the number of words per line slightly
      def weighted_sample_index(valid_word_indices)

        weighted_word_indices(valid_word_indices).sample

      end

      def weighted_word_indices(valid_word_indices)

        out = []
        valid_word_indices.each do |valid_word_index|
          if @word_templates[valid_word_index].syllables > 0
            # weight this word more heavily
            EXISTING_SYLLABLES_PRIORITY.times do
              out << valid_word_index
            end
          else
            out << valid_word_index
          end
        end
        out

      end

  end

end