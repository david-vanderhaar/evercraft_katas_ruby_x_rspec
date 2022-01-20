require 'spec_helper'
require 'character'
require 'events/attack_event'

describe Character do

    let(:character) { Character.new }

    it 'has a name' do
        expect(character.name).to be_a(String)
    end

    it 'can be given a name' do
        name = 'Faramir'
        expect(character.name= name).to eq name
    end

    it 'has an alignment' do
        expect(ALIGNMENT[:good]).to include(character.alignment)
    end

    it 'can be given an alignment' do
        alignment = ALIGNMENT[:good]
        expect(character.alignment= alignment).to eq alignment
    end

    it 'can not be given a non-existent alignment' do
        expect { character.alignment= 'Bloop Blorp' }.to raise_error("select from the following alignments: #{ALIGNMENT.values}")
    end

    it 'has an armor class which defaults to 10' do 
        expect(character.armor_class).to eq 10
    end

    it 'has a hit point value which defaults to 5' do
        expect(character.hit_points).to eq 5
    end

    it 'has a strength ability score of 10' do
        expect(character.strength.score).to eq 10
    end

    it 'has a strength modifier of 0' do
        expect(character.strength.modifier).to eq 0
    end

    it 'has a dexterity ability score of 10' do
        expect(character.dexterity.score).to eq 10
    end

    it 'has a dexterity modifier of 0' do
        expect(character.dexterity.modifier).to eq 0
    end

    it 'has a wisdom ability score of 10' do
        expect(character.wisdom.score).to eq 10
    end

    it 'has a wisdom modifier of 0' do
        expect(character.wisdom.modifier).to eq 0
    end

    it 'has a constitution ability score of 10' do
        expect(character.constitution.score).to eq 10
    end

    it 'has a constitution modifier of 0' do
        expect(character.constitution.modifier).to eq 0
    end

    it 'has a intelligence ability score of 10' do
        expect(character.intelligence.score).to eq 10
    end

    it 'has a intelligence modifier of 0' do
        expect(character.intelligence.modifier).to eq 0
    end

    it 'does more damage when it has a high strength score' do
        allow(character).to receive(:strength).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:strength], score: 20)
        expect(character.damage).to eq 1 + 5
    end

    it 'does less damage when it has a low strength score' do
        allow(character).to receive(:strength).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:strength], score: 12)
        expect(character.damage).to eq 1 + 1
    end

    it 'does at least 1 damage when it has a very low strength score' do
        allow(character).to receive(:strength).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:strength], score: 1)
        expect(character.damage).to eq 1
    end

    it 'has a higher armor class when it has a high dexterity score' do
        allow(character).to receive(:dexterity).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:dexterity], score: 20)
        expect(character.armor_class).to eq 15
    end

    it 'has a very low armor class when it has a low dexterity score' do
        allow(character).to receive(:dexterity).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:dexterity], score: 1)
        expect(character.armor_class).to eq 5
    end

    it 'defaults to a higher amount of hit points when it has a high constitution score' do
        allow(character).to receive(:constitution).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:constitution], score: 20)
        expect(character.hit_points).to eq 10
    end

    it 'defaults to a lower amount of hit points when it has a low constitution score' do
        allow(character).to receive(:constitution).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:constitution], score: 9)
        expect(character.hit_points).to eq 4
    end

    it 'defaults to at least 1 hit point when it has a very low constitution score' do
        allow(character).to receive(:constitution).and_return AbilityScore.new(name: ABILITY_SCORE_NAME[:constitution], score: 1)
        expect(character.hit_points).to eq 1
    end

    it 'has a level of 1 by default' do
        expect(character.level).to eq 1
    end

    it 'has a level of 2 if experience is >= 1000 and < 2000' do
        character.experience= 1000
        expect(character.level).to eq 2
    end

    it 'levels up when crossing an experience threshhold divisible by 1000' do
        expect(character).to receive(:level_up)
        character.gain_experience(1000)
    end

    it 'does not level up when an experience threshhold divisible by 1000 is not crossed' do
        expect(character).not_to receive(:level_up)
        character.gain_experience(10)
    end

    context 'modifies an attack roll by adding 1 for every even level' do
        it 'adds 0 to the roll when level is 1' do
            allow(character).to receive(:level).and_return 1
            expect(character.modify_attack_roll(1)).to eq 1
        end

        it 'adds 1 to the roll when level is 2' do
            allow(character).to receive(:level).and_return 2
            expect(character.modify_attack_roll(1)).to eq 2                      
        end

        it 'adds 1 to the roll when level is 3' do
            allow(character).to receive(:level).and_return 3
            expect(character.modify_attack_roll(1)).to eq 2                        
        end

        it 'adds 2 to the roll when level is 4' do
            allow(character).to receive(:level).and_return 4
            expect(character.modify_attack_roll(1)).to eq 3                        
        end
    end

    context 'when attacking' do

        it 'returns an Attack event' do
            opponent = Character.new

            expect(character.attack(opponent)).to be_an AttackEvent
        end
        
        it 'can not attack an entiity that does not have hit points' do
            mountain = "You can't hurt me"
            
            expect { character.attack(mountain) }.to raise_error("this object does not have hit points, it cannot be attacked")
        end

    end
    
end