require File.expand_path('word_template.rb', File.dirname(__FILE__))
require File.expand_path('line_template.rb', File.dirname(__FILE__))

module HaikuGadget

  module LineTemplates

    COMMON_LINES = [

      # noun(s) act on mass/abstract noun
      LineTemplate.new(
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb, 1, :any, 1),
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:mass_noun, 1)
      ),

      # imperative action (command)
      LineTemplate.new(
        WordTemplate.new(:verb, 1, :plural),
        WordTemplate.new(:determiner, 0, :plural),
        WordTemplate.new(:adjective, 0, :plural),
        WordTemplate.new(:noun, 1, :plural),
        WordTemplate.new(:verb_adverb)
      ),

      # mass/abstract noun is adj
      LineTemplate.new(
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:adjective, 0, :common),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:to_be, 1, :singular),
        WordTemplate.new(:adjective, 1, :any)
      ),

      # noun(s) of mass/abstract noun acts
      LineTemplate.new(
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.custom('of', 1),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:verb_self, 1, :any, 1)
      ),

      # adj noun is adj
      LineTemplate.new(
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:to_be, 1, :any, 1),
        WordTemplate.new(:adjective, 1, :any, 1)
      ),

      # metaphors
      [
        LineTemplate.new(
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1),
          WordTemplate.custom('is like', 2),
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1)
        ),

        LineTemplate.new(
          WordTemplate.new(:adjective, 0, :plural),
          WordTemplate.new(:noun, 1, :plural),
          WordTemplate.custom('are like', 2),
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1)
        ),

        LineTemplate.new(
          WordTemplate.new(:determiner, 0, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.custom('is like', 2),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:adjective, 0, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2)
        ),

        LineTemplate.new(
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.custom('are like', 2),
          WordTemplate.new(:adjective, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2)
        )
      ],

      # i/we/they/you act on noun(s)
      [
        LineTemplate.new(
          WordTemplate.custom(%w(i we they you), 1),
          WordTemplate.new(:verb, 1, :plural),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:adjective, 0, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2),
          WordTemplate.new(:verb_adverb)
        ),

        LineTemplate.new(
          WordTemplate.custom(%w(i we they you), 1),
          WordTemplate.new(:verb, 1, :plural),
          WordTemplate.new(:determiner, 0, :plural, 2),
          WordTemplate.new(:adjective, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2),
          WordTemplate.new(:verb_adverb)
        )
      ],

      # noun(s) act on noun(s)
      [
        LineTemplate.new(
          WordTemplate.new(:determiner, 0, :any, 1),
          WordTemplate.new(:noun, 1, :any, 1),
          WordTemplate.new(:verb, 1, :any, 1),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2)
        ),

        LineTemplate.new(
          WordTemplate.new(:determiner, 0, :any, 1),
          WordTemplate.new(:noun, 1, :any, 1),
          WordTemplate.new(:verb, 1, :any, 1),
          WordTemplate.new(:determiner, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2)
        )
      ]
    ]

    MIDDLE_LINES = [
      # (and) noun(s) act
      [
        LineTemplate.new(
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 1, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.new(:verb_self, 1, :singular, 1),
          WordTemplate.new(:verb_adverb)
        ),

        LineTemplate.new(  
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 0, :plural, 1),
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.new(:verb_self, 1, :plural, 1),
          WordTemplate.new(:verb_adverb)
        )
      ]
    ]

    BOTTOM_LINES = [
      # (and) noun(s) act
      [
        LineTemplate.new(
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 1, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.new(:verb_self, 1, :singular, 1)
        ),

        LineTemplate.new(
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 0, :plural, 1),
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.new(:verb_self, 1, :plural, 1)
        )
      ]
    ]

    SHORT_LINES = [
      [
        LineTemplate.new(
          WordTemplate.custom([
            'it is', 'it was',
            'that is', 'that was',
            'we are', 'we were',
            'they are', 'they were'
          ], 2),
          WordTemplate.new(:adjective_adverb),
          WordTemplate.new(:adjective, 1, :singular)
        ),

        LineTemplate.new(
          WordTemplate.custom(%w(it's that's we're they're), 1),
          WordTemplate.new(:adjective_adverb),
          WordTemplate.new(:adjective, 1, :singular)
        )
      ]
    ]

    ALL_TOP_LINES = [
      COMMON_LINES,
      SHORT_LINES
    ].flatten(1)

    ALL_MIDDLE_LINES = [
      COMMON_LINES,
      MIDDLE_LINES
    ].flatten(1)

    ALL_BOTTOM_LINES = [
      COMMON_LINES,
      BOTTOM_LINES,
      SHORT_LINES
    ].flatten(1)

  end

end