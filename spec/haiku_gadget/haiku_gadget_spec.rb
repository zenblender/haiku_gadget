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

    describe 'with basic line template' do

      line_template = LineTemplate.new(
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb_self, 1, :any, 1)
      )

      expected_dist_length = LineTemplate::EXISTING_SYLLABLES_PRIORITY * 2 + 1

      it 'should give the correct weighted word index distribution' do

        # word templates that start with 0 syllables are less likely to be
        # selected for adding syllables (prefer fewer words per line)
        weighted_word_indices = line_template.clone.send :weighted_word_indices, [0, 1, 2]
        
        expect(weighted_word_indices.length).to be expected_dist_length

        # index 0 should be in there once
        expect(weighted_word_indices.select { |n| n == 0 }.length).to eq 1
        # and indeices 1 and 2 should each be in there LineTemplate::EXISTING_SYLLABLES_PRIORITY times
        expect(weighted_word_indices.select { |n| n == 1 }.length).to eq LineTemplate::EXISTING_SYLLABLES_PRIORITY
        expect(weighted_word_indices.select { |n| n == 2 }.length).to eq LineTemplate::EXISTING_SYLLABLES_PRIORITY

      end

      it 'should statistically favor existing syllable words' do
        # test the actual results of the resulting weighted indexes
        word_indices = []
        10000.times do
          curr_line_template = line_template.clone
          word_indices << curr_line_template.send(:weighted_sample_index, [0, 1, 2])
        end

        word_index_counts = []
        3.times do |i|
          word_index_counts[i] = word_indices.select { |n| n == i }.length
        end

        expected_percs = []
        expected_percs[0] = (1 / expected_dist_length.to_f) * 100
        expected_percs[1] = (LineTemplate::EXISTING_SYLLABLES_PRIORITY / expected_dist_length.to_f) * 100
        expected_percs[2] = (LineTemplate::EXISTING_SYLLABLES_PRIORITY / expected_dist_length.to_f) * 100

        threshold_perc = 3

        3.times do |i|
          actual_perc = (word_index_counts[i] / word_indices.length.to_f) * 100
          puts "stats for word index #{i} -- expected: #{expected_percs[i]}%, actual: #{actual_perc}%"

          low_perc = expected_percs[i] - threshold_perc
          high_perc = expected_percs[i] + threshold_perc
          allowed_range = (low_perc...high_perc)
          expect(allowed_range).to include actual_perc
        end

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