require File.expand_path('word_type.rb', File.dirname(__FILE__))

module HaikuGadget

  class WordTemplate

    attr_reader :word_type, :obj_num
    attr_accessor :syllables, :plurality

    def initialize(base_symbol_or_word_type, syllables = 0, plurality = :none, obj_num = 0)

      if base_symbol_or_word_type.is_a? HaikuGadget::WordType
        # use provided (custom) WordType
        word_type = base_symbol_or_word_type
      else
        # look up word type based on symbol
        word_type = Dictionary::WORD_TYPES[base_symbol_or_word_type]
      end

      fail "unknown word type '#{base_symbol_or_word_type.to_s}'" unless word_type

      # check if template plurality needs to be set or changed
      if word_type.can_be_plural
        plurality = :any if plurality == :none
      else
        plurality = :none
      end

      @word_type = word_type
      @syllables = syllables
      @plurality = plurality
      @obj_num = obj_num

    end

    def self.custom(word_list, syllables)

      WordTemplate.new WordType.custom(word_list), syllables

    end

  end

end
