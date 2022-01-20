class AbilityScore
    attr_accessor :name, :score

    def initialize(name: 'Strength', score: 10)
        @name = name
        @score = score
    end

    def name
        @name ||= ABILITY_SCORE_NAME[:strength]
    end

    def name=(value)
        if !ABILITY_SCORE_NAME.values.include?(value)
            raise "select from the following alignments: #{ABILITY_SCORE_NAME.values}"
        end
    end

    def score
        @score ||= 10
    end

    def score=(value)
        @score = value.clamp(1, 20)
    end

    def modifier
        ABILITY_SCORE_MODIFIER_MAP[self.score]
    end

    def modify(value)
        value + self.modifier
    end
end

ABILITY_SCORE_NAME = {
    strength: 'Strength',
    dexterity: 'Dexterity',
    constitution: 'Constitution',
    wisdom: 'Wisdom',
    intelligence: 'Intelligence',
    charisma: 'Charisma'
}

ABILITY_SCORE_MODIFIER_MAP = {
    1 => -5,
    2 => -4,
    3 => -4,
    4 => -3,
    5 => -3,
    6 => -2,
    7 => -2,
    8 => -1,
    9 => -1,
    10 => 0,
    11 => 0,
    12 => 1,
    13 => 1,
    14 => 2,
    15 => 2,
    16 => 3,
    17 => 3,
    18 => 4,
    19 => 4,
    20 => 5,
}