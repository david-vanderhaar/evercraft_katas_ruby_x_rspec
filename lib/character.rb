require_relative './events/attack_event'
require_relative './ability_score'

class Character
    attr_accessor :name, :alignment, :armor_class, :hit_points, :experience

    def initialize(
        name: '', 
        alignment: 'Good', 
        armor_class: 10, 
        hit_points: 5,
        strength: 10,
        dexterity: 10,
        wisdom: 10,
        constitution: 10,
        intelligence: 10
    )
        @name = name
        @alignment = alignment
        @armor_class = armor_class
        @base_strength_score = strength
        @base_dexterity_score = dexterity
        @base_wisdom_score = wisdom
        @base_constitution_score = constitution
        @base_intelligence_score = intelligence
        @base_hit_points = hit_points
        @experience = 0
    end

    def alignment= (value)
        if !ALIGNMENT.values.include?(value)
            raise "select from the following alignments: #{ALIGNMENT.values}"
        end

        @alignment = value
    end

    def level
        (@experience / 1000).floor + 1
    end

    def level_up
        current_hit_points = hit_points
        hit_points= (current_hit_points + [1, constitution.modify(5)].max)
    end

    def leveled_up?(previous_level, current_level)
        (current_level - previous_level) > 0
    end

    def gain_experience(value)
        previous_level = level

        @experience += value

        level_up if leveled_up?(previous_level, level)
    end

    def attack(defender)
        raise "this object does not have hit points, it cannot be attacked" if !defender.respond_to?(:hit_points)

        AttackEvent.new(attacker: self, defender: defender)
    end

    def modify_attack_roll(roll)
        roll + (level / 2).floor
    end

    def damage
        [1, strength.modify(self.base_damage)].max
    end

    def base_damage
        1
    end

    def armor_class
        dexterity.modify(self.base_armor_class)
    end

    def base_armor_class
        @armor_class
    end

    def hit_points
        @hit_points ||= [1, constitution.modify(@base_hit_points)].max
    end

    def is_dead?
        self.hit_points <= 0
    end

    def strength
        @strength ||= AbilityScore.new(name: ABILITY_SCORE_NAME[:strength], score: @base_strength_score)
    end
    
    def dexterity
        @dexterity ||= AbilityScore.new(name: ABILITY_SCORE_NAME[:dexterity], score: @base_dexterity_score)
    end
    
    def wisdom
        @wisdom ||= AbilityScore.new(name: ABILITY_SCORE_NAME[:wisdom], score: @base_wisdom_score)
    end
    
    def constitution
        @constitution ||= AbilityScore.new(name: ABILITY_SCORE_NAME[:constitution], score: @base_constitution_score)
    end
    
    def intelligence
        @intelligence ||= AbilityScore.new(name: ABILITY_SCORE_NAME[:intelligence], score: @base_intelligence_score)
    end
end

ALIGNMENT = {
    good: 'Good',
    bad: 'Bad',
    neutral: 'Neutral',
}