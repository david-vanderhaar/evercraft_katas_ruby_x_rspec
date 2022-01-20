require 'spec_helper'
require 'die'

describe Die do
    let(:die) { Die.new }

    it 'has a number of sides that defaults to 20' do
        expect(die.sides).to eq 20
    end
    
    context 'when rolled' do
        it 'gives a result that is between 1 and die.sides' do
            expect(die.roll).to be_between(1, die.sides).inclusive
        end
    end
end