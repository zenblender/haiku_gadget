module HaikuGadget

  describe 'HaikuGadget' do

    describe 'with default dictionary' do

      dict_path = '../../lib/words.yml'

      before(:each) do
        Dictionary.init! dict_path
      end

      it 'should have various types of words' do
        [:noun, :verb, :adjective].each do |valid_symbol|
          word_type = Dictionary::WORD_TYPES[valid_symbol]

          # check words? method for true/false
          expect(word_type.words? 1).to eq(true)

          # check get_words method for actual string response
          expect(word_type.get_word 1).to be_kind_of(String)
        end
      end

      it 'should not have a non-existant word type' do
        [:doesnt_exist, :also_is_wrong, nil].each do |invalid_symbol|
          invalid_word_type = Dictionary::WORD_TYPES[invalid_symbol]

          # check words? method for true/false
          expect(Dictionary.words? invalid_word_type, 1).to eq(false)

          # get_word should return nil
          expect(Dictionary.get_word invalid_word_type, 1).to be_nil
        end
      end

      it 'should fail if asking for an invalid number (or data type) of syllables' do
        [:noun, :invalid_word_type, nil].each do |symbol|
          word_type = Dictionary::WORD_TYPES[symbol]

          # check both valid and invalid word type symbols
          [0, -1, 9, 'abc', nil, 2.5].each do |invalid_syllables|
            # check words? method for true/false
            expect(Dictionary.words? word_type, invalid_syllables).to eq(false)

            # get_word should return nil
            expect(Dictionary.get_word word_type, invalid_syllables).to be_nil
          end
        end
      end

      it 'should contain some random expected words' do

        %w(banana advise the sadly moon red my).each do |word|

          expect(Dictionary.contains_word_anywhere? word).to eq true

        end

      end

      # this test ensures that no words are being parsed as data types other than String,
      # for example, the word 'no' gets parsed as false and needs to be in quotes in the YAML file
      it 'should contain only string data types (inside arrays)' do

        expect(Dictionary.contains_valid_data_types?).to eq true

      end

    end

    describe 'with single possibility test dictionary' do
      # these tests use a yaml file in which the randomness is removed because
      # there is only one word of each type in the dictionary

      dict_path = '../../spec/test_words_single.yml'

      haiku_template = HaikuTemplate.new [
        LineTemplate.new(
          WordTemplate.new(:adjective, 1, :singular, 1),  # red
          WordTemplate.new(:noun, 1, :singular, 1),       # thing
          WordTemplate.new(:verb_self, 3, :singular, 1)   # meditates
        ),
        LineTemplate.new(
          WordTemplate.new(:determiner, 1, :plural, 1),   # the
          WordTemplate.new(:noun, 3, :plural, 1),         # samurais
          WordTemplate.new(:verb, 1, :plural, 1),         # see
          WordTemplate.new(:noun, 2, :singular, 2)        # zombie
        ),
        LineTemplate.new(
          WordTemplate.new(:adjective, 2, :any, 1),  # orange
          WordTemplate.new(:noun, 2, :any, 1),       # zombie(s)
          WordTemplate.new(:verb_self, 1, :any, 1)   # fight(s)
        )
      ]

      before(:each) do
        Dictionary.init! dict_path
      end

      it 'should return a predictable haiku (when generated all at once)' do

        10.times do
          # do 10 times so the plurality randomization hits multiple possibilities
          haiku_lines = HaikuGadget.haiku_lines haiku_template

          expect(haiku_lines[0]).to eq('red thing meditates')
          expect(haiku_lines[1]).to eq('the samurais see zombie')

          # third line can randomly be one of two options
          last_lines = ['orange zombie fights', 'orange zombies fight']
          expect(last_lines).to include(haiku_lines[2])
        end

      end

      it 'should return a predictable haiku (when lines are generated individually)' do

        10.times do
          # do 10 times so the plurality randomization hits multiple possibilities
          top_line = HaikuGadget.top_line haiku_template.template_matrix[0]
          middle_line = HaikuGadget.middle_line haiku_template.template_matrix[1]
          bottom_line = HaikuGadget.bottom_line haiku_template.template_matrix[2]

          haiku = [top_line, middle_line, bottom_line].join(' | ')

          valid_haikus = [
            'red thing meditates | the samurais see zombie | orange zombie fights',
            'red thing meditates | the samurais see zombie | orange zombies fight'
          ]

          expect(valid_haikus).to include(haiku)

        end
      end

    end

    describe 'with deeply-nested test dictionary' do

      dict_path = '../../spec/test_words_nested.yml'

      before(:each) do
        Dictionary.init! dict_path
      end

      it 'should return a haiku containing expected words' do

        haiku_template = HaikuTemplate.new [
          LineTemplate.new(WordTemplate.new :mass_noun, 5),
          LineTemplate.new(WordTemplate.new :mass_noun, 7),
          LineTemplate.new(WordTemplate.new :mass_noun, 5)
        ]

        haiku = HaikuGadget.haiku nil, haiku_template

        puts "haiku from deeply-nested words: #{haiku.join(' | ')}"

        five_syl_words = %w(personality california university)
        seven_syl_words = %w(unconventionality territoriality enthusiastically)

        expect(five_syl_words).to include(haiku[0])
        expect(seven_syl_words).to include(haiku[1])
        expect(five_syl_words).to include(haiku[2])

      end

    end

    describe 'with built-in line templates' do

      it 'should not have invalid syllable defaults' do

        template_pairs = [
          [LineTemplates::ALL_TOP_LINES.flatten, 5],
          [LineTemplates::ALL_MIDDLE_LINES.flatten, 7],
          [LineTemplates::ALL_BOTTOM_LINES.flatten, 5]
        ]

        template_pairs.each do |pair|
          line_templates, syllables = pair

          line_templates.each do |line_template|

            expect(line_template.current_syllables).to be <= syllables

          end

        end

      end

    end
     
  end

end