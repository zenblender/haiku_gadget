require File.expand_path('word_template.rb', File.dirname(__FILE__))

module HaikuGadget

  module LineTemplates

    COMMON_LINES = [
      [
        # noun(s) act on mass/abstract noun
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:verb, 1, :any, 1),
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:mass_noun, 1)
      ], [
        # imperative action (command)
        WordTemplate.new(:adverb, 2),
        WordTemplate.new(:verb, 1, :plural),
        WordTemplate.new(:determiner, 0, :plural),
        WordTemplate.new(:adjective, 0, :plural),
        WordTemplate.new(:noun, 1, :plural)
      ], [
        # mass/abstract noun is adj
        WordTemplate.new(:mass_noun_determiner),
        WordTemplate.new(:adjective, 0, :common),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:to_be, 1, :singular),
        WordTemplate.new(:adjective, 1, :any)
      ], [
        # noun(s) of mass/abstract noun acts
        WordTemplate.new(:determiner, 0, :any, 1),
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.custom('of', 1),
        WordTemplate.new(:mass_noun, 1),
        WordTemplate.new(:verb_self, 1, :any, 1)
      ], [
        # adj noun is adj
        WordTemplate.new(:adjective, 0, :any, 1),
        WordTemplate.new(:noun, 1, :any, 1),
        WordTemplate.new(:to_be, 1, :any, 1),
        WordTemplate.new(:adjective, 1, :any, 1)
      ], [
        # metaphors
        [
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1),
          WordTemplate.custom('is like', 2),
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1)
        ], [
          WordTemplate.new(:adjective, 0, :plural),
          WordTemplate.new(:noun, 1, :plural),
          WordTemplate.custom('are like', 2),
          WordTemplate.new(:adjective, 0, :common),
          WordTemplate.new(:mass_noun, 1)
        ], [
          WordTemplate.new(:determiner, 0, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.custom('is like', 2),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:adjective, 0, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2)
        ], [
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.custom('are like', 2),
          WordTemplate.new(:adjective, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2)
        ]
      ], [
        # i/we/they act on noun(s)
        [
          WordTemplate.custom(%w(i we they), 1),
          WordTemplate.new(:verb, 1, :plural),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:adjective, 0, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2),
          WordTemplate.new(:adverb)
        ], [
          WordTemplate.custom(%w(i we they), 1),
          WordTemplate.new(:verb, 1, :plural),
          WordTemplate.new(:determiner, 0, :plural, 2),
          WordTemplate.new(:adjective, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2),
          WordTemplate.new(:adverb)
        ]
      ], [
        # noun(s) act on noun(s)
        [
          WordTemplate.new(:determiner, 0, :any, 1),
          WordTemplate.new(:noun, 1, :any, 1),
          WordTemplate.new(:verb, 1, :any, 1),
          WordTemplate.new(:determiner, 1, :singular, 2),
          WordTemplate.new(:noun, 1, :singular, 2)
        ], [
          WordTemplate.new(:determiner, 0, :any, 1),
          WordTemplate.new(:noun, 1, :any, 1),
          WordTemplate.new(:verb, 1, :any, 1),
          WordTemplate.new(:determiner, 0, :plural, 2),
          WordTemplate.new(:noun, 1, :plural, 2)
        ]
      ]
    ]

    MIDDLE_LINES = [
      [
        # (and) noun(s) act
        [
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 1, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.new(:verb_self, 1, :singularß, 1),
          WordTemplate.new(:adverb)
        ], [
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 0, :plural, 1),
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.new(:verb_self, 1, :plural, 1),
          WordTemplate.new(:adverb)
        ]
      ]
    ]

    BOTTOM_LINES = [
      [
        # (and) noun(s) act
        [
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 1, :singular, 1),
          WordTemplate.new(:adjective, 0, :singular, 1),
          WordTemplate.new(:noun, 1, :singular, 1),
          WordTemplate.new(:verb_self, 1, :singular, 1)
        ], [
          WordTemplate.new(:transition_join),
          WordTemplate.new(:determiner, 0, :plural, 1),
          WordTemplate.new(:adjective, 0, :plural, 1),
          WordTemplate.new(:noun, 1, :plural, 1),
          WordTemplate.new(:verb_self, 1, :plural, 1)
        ]
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

  end

end