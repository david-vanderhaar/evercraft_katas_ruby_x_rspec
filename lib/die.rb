class Die
    attr_reader :sides

    def initialize(sides: 20)
        @sides = sides
    end

    def roll
        rand(1..sides)
    end
end