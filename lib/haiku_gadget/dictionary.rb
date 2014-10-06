require 'yaml'

require File.expand_path('word_type.rb', File.dirname(__FILE__))

module HaikuGadget

  module Dictionary

    DEFAULT_DICT_PATH = '../words.yml'

    WORD_TYPES = {
      determiner:             WordType.new(:determiner, true),
      to_be:                  WordType.new(:to_be, true),
      adjective:              WordType.new(:adjective, true),
      adjective_adverb:       WordType.new(:adjective_adverb),
      noun:                   WordType.new(:noun, true, :plural),
      mass_noun:              WordType.new(:mass_noun),
      mass_noun_determiner:   WordType.new(:mass_noun_determiner),
      verb:                   WordType.new(:verb, true, :singular),
      verb_self:              WordType.new(:verb_self, true, :singular),
      verb_adverb:            WordType.new(:verb_adverb),
      transition_join:        WordType.new(:transition_join)
    }

    def self.suffixed_symbol(base_symbol, suffix_symbol)
      "#{base_symbol.to_s}_#{suffix_symbol.to_s}".to_sym
    end

    # copies words from _common into _singular and _plural
    # modifies dict structure in place, doesn't return anything of consequence
    def self.complete_plurality(dict, word_type)

      # words that have no plurality considerations don't need to do anything here
      return unless word_type.can_be_plural

      base_symbol = word_type.base_symbol

      common_symbol = Dictionary.suffixed_symbol base_symbol, :common

      plural_symbols = [:singular, :plural]
      symbols = [
        Dictionary.suffixed_symbol(base_symbol, :singular),
        Dictionary.suffixed_symbol(base_symbol, :plural)
      ]

      # make sure there is a common list structure
      dict[common_symbol] ||= []

      # make sure there are singular/plural word list structures
      symbols.each do |symbol|
        dict[symbol] ||= []
      end

      plural_symbols.each do |plural_symbol|

        symbol = Dictionary.suffixed_symbol base_symbol, plural_symbol

        # make sure singular and plural structures exist
        dict[symbol] ||= []

        # make array lengths equal to the max of the common, singular and plural arrays
        while dict[symbol].length < [symbols.map { |s| dict[s].length }, dict[common_symbol].length].flatten.max
          dict[symbol] << []
        end

        # add common words to current word list, respecting syllables and plurality
        dict[symbol].each_index do |i|
          if word_type.add_s_target == plural_symbol
            # currently building a list in which the words should have an 's' added when copying from _common
            dict[symbol][i] += Dictionary.add_s_to_all(dict[common_symbol][i]) if dict[common_symbol][i]
          else
            # not adding an 's' in this case, or building the singular word list
            dict[symbol][i] += dict[common_symbol][i] if dict[common_symbol][i]
          end
        end
      end

    end

    def self.add_s_to_all(word_list)
      out = []
      word_list.each do |word_or_array|
        if word_or_array.is_a? Array
          # recursively call again and add the nested array
          out << Dictionary.add_s_to_all(word_or_array)
        else
          out << "#{word_or_array}s"
        end
      end
      out
    end

    def self.contains_word_anywhere?(word)
      @@dict.each do |key, array|
        return true if array.flatten.include? word
      end
      false
    end

    def self.contains_valid_data_types?
      @@dict.each do |key, array|
        array.flatten.each do |item|
          puts "error: #{item} in #{key.to_s} is a #{item.class}" if item.class != String
          return false unless item.is_a? String
        end
      end
      true
    end

    # force load of dictionary from yaml file now
    def self.load(path = DEFAULT_DICT_PATH)
      dict = YAML.load_file(File.expand_path(path, File.dirname(__FILE__)))

      WORD_TYPES.each do |k, wt|
        Dictionary.complete_plurality(dict, wt)
      end

      dict
    end

    # load dictionary if not yet done, using default dictionary yaml path
    def self.init
      @@dict ||= load
    end

    # force load/reload of dictionary, optionally passing a custom path to a dictionary yaml file
    def self.init!(path = DEFAULT_DICT_PATH)
      @@dict = load path
    end

    # if available, returns a random word of the given type and number of syllables
    def self.get_word(word_type, syllables, plurality = :none)

      Dictionary.init

      # validate word_type
      return nil unless word_type

      # validate syllables input
      return nil unless syllables.is_a?(Fixnum) && syllables > 0

      dict_symbol = word_type.dict_symbol plurality
      if @@dict[dict_symbol] && @@dict[dict_symbol][syllables - 1]
        word_or_array = @@dict[dict_symbol][syllables - 1].sample
        while word_or_array.is_a? Array
          # this item contains a nested list of items (to limit chances of nested item being selected)
          # sample from nested array and try again to find a word ("leaf node")
          word_or_array = word_or_array.sample
        end
        # current item is a word and not a nested list, return it
        word_or_array
      else
        nil
      end
    end

    def self.words?(word_type, syllables, plurality = :none)
      !Dictionary.get_word(word_type, syllables, plurality).nil?
    end

  end

end