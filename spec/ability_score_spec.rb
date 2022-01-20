require 'ability_score'

describe AbilityScore do
    let(:ability_score) { AbilityScore.new }

    it 'has an name' do
        expect(ABILITY_SCORE_NAME[:strength]).to include(ability_score.name)
    end

    it 'can be given an name' do
        name = ABILITY_SCORE_NAME[:strength]
        expect(ability_score.name= name).to eq name
    end

    it 'can not be given a non-existent name' do
        expect { ability_score.name= 'Bloop Blorp' }.to raise_error("select from the following alignments: #{ABILITY_SCORE_NAME.values}")
    end

    it 'has a score that defaults to 10' do
        expect(ability_score.score).to eq 10
    end

    it 'has a score that is between 1 and 20' do
        expect(ability_score.score).to be_between(1, 20).inclusive    
    end

    it 'can only be given a score >= 1' do
        ability_score.score= 0
        expect(ability_score.score).to eq 1
    end

    it 'can only be given a score <= 20' do
        ability_score.score= 21
        expect(ability_score.score).to eq 20
    end

    describe '.modifier' do
        ABILITY_SCORE_MODIFIER_MAP.each do |key, value|
            it "gives a modifier of #{value} when score is #{key}" do
                ability_score.score= key
                expect(ability_score.modifier).to eq value
            end
        end

        context 'every possible score value (1-20) gives a modifer' do
            (1..20).each do |value|
                it 'gives a modifer' do
                    ability_score.score= value
                    expect(ability_score.modifier).not_to eq nil
                end
            end
        end
    end

    describe '.modify' do
        it 'increases the value when the score is high' do
            ability_score.score= 12
            expect(ability_score.modify(10)).to eq 11
        end

        it 'decreases the value when the score is low' do
            ability_score.score= 9
            expect(ability_score.modify(10)).to eq 9
        end

        it 'does nothing to the value when the score is neutral' do
            ability_score.score= 10
            expect(ability_score.modify(10)).to eq 10
        end
    end
end