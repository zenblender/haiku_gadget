module HaikuHipster

  describe 'HaikuHipster' do

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

    end

    describe 'with single possibility test dictionary' do
      # these tests use a yaml file in which the randomness is removed because
      # there is only one word of each type in the dictionary

      dict_path = '../../spec/test_words_single.yml'

      haiku_template = HaikuTemplate.new [
        [
          WordTemplate.new(:adjective, 1, :singular, 1),  # red
          WordTemplate.new(:noun, 1, :singular, 1),       # thing
          WordTemplate.new(:verb_self, 3, :singular, 1)   # meditates
        ], [
          WordTemplate.new(:determiner, 1, :plural, 1),   # the
          WordTemplate.new(:noun, 3, :plural, 1),         # samurais
          WordTemplate.new(:verb, 1, :plural, 1),         # see
          WordTemplate.new(:noun, 2, :singular, 2)        # zombie
        ], [
          WordTemplate.new(:adjective, 2, :any, 1),  # orange
          WordTemplate.new(:noun, 2, :any, 1),       # zombie(s)
          WordTemplate.new(:verb_self, 1, :any, 1)   # fight(s)
        ]
      ]

      before(:each) do
        Dictionary.init! dict_path
      end

      it 'should return a predictable haiku (when generated all at once)' do

        10.times do
          # do 10 times so the plurality randomization hits multiple possibilities
          haiku_lines = HaikuHipster.haiku_lines haiku_template

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
          top_line = HaikuHipster.top_line haiku_template.template_matrix[0]
          middle_line = HaikuHipster.middle_line haiku_template.template_matrix[1]
          bottom_line = HaikuHipster.bottom_line haiku_template.template_matrix[2]

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
          [WordTemplate.new(:mass_noun, 5)],
          [WordTemplate.new(:mass_noun, 7)],
          [WordTemplate.new(:mass_noun, 5)]
        ]

        haiku = HaikuHipster.haiku nil, haiku_template

        puts "haiku from deeply-nested words: #{haiku.join(' | ')}"

        five_syl_words = %w(personality california university)
        seven_syl_words = %w(unconventionality territoriality enthusiastically)

        expect(five_syl_words).to include(haiku[0])
        expect(seven_syl_words).to include(haiku[1])
        expect(five_syl_words).to include(haiku[2])

      end

    end
     
  end

end