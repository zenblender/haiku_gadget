require File.expand_path('word_template.rb', File.dirname(__FILE__))

module HaikuGadget

  module LineTemplates

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

  end

end