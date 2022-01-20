require_relative './event'

class AttackEvent < Event
    attr_accessor :attacker, :defender

    def initialize(attacker: nil, defender: nil)
        @attacker = attacker
        @defender = defender
    end

    def perform
        raise_if_performed
        d20 = self.get_die
        roll = attacker.modify_attack_roll(d20.roll)
        is_natural_20 = roll == 20
        result = self.check(roll, is_natural_20)
        self.resolve(result, is_natural_20)
        self.result= result
    end

    def get_die
        Die.new(sides: 20)
    end

    def check(roll, is_natural_20)
        if is_natural_20
            result = true
        else
            result = roll >= @defender.armor_class
        end

        result
    end

    def resolve(check_passed, is_natural_20)
        damage = attacker.damage
        damage *= 2 if is_natural_20
        if check_passed
            defender.hit_points= defender.hit_points - damage
            attacker.gain_experience(10)
        end
    end

end