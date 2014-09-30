module HaikuGadget

  class WordType

    attr_reader :base_symbol, :can_be_plural, :add_s_target

    def initialize(base_symbol, can_be_plural = false, add_s_target = nil, custom_words = [])
      @base_symbol = base_symbol
      @can_be_plural = can_be_plural
      @add_s_target = add_s_target

      # make sure custom_words is an array (allows convenient input of a single string)
      @custom_words = custom_words.is_a?(Array) ? custom_words : [custom_words]
    end

    def self.custom(custom_words = [])
      WordType.new :custom, false, nil, custom_words
    end

    # translates the base symbol type into a _singular or _plural one if necessary
    # for doing dictionary lookups
    def dict_symbol(plurality)
      # do not allow plurality of :none for a word that has plurality
      # this is a redundant error check and should not happen
      plurality = [:singular, :plural].sample if @can_be_plural && plurality == :none

      if @can_be_plural && [:singular, :plural].include?(plurality)
        # word can be plural
        "#{@base_symbol.to_s}_#{plurality.to_s}".to_sym
      else
        # word type is not relevent to plurality
        @base_symbol
      end
    end

    def get_word(syllables, plurality = :none)
      if base_symbol == :custom
        @custom_words.sample
      else
        Dictionary.get_word self, syllables, plurality
      end
    end

    def words?(syllables, plurality = :none)
      if base_symbol == :custom
        !get_word(syllables, plurality).nil?
      else
        Dictionary.words? self, syllables, plurality
      end
    end

  end


end