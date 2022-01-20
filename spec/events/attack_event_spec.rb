require 'spec_helper'
require 'events/attack_event'

describe AttackEvent do
    # it_behaves_like "an Event"

    let(:attacker) { Character.new }
    let(:defender) { Character.new(armor_class: 10) }
    let(:event) { AttackEvent.new(attacker: attacker, defender: defender) }

    it 'must have an attacker' do
        expect(event.attacker).to be_a Character
    end
    
    it 'must have a defender' do
        expect(event.defender).to be_a Character
    end

    describe '.perform' do

        it 'should roll a d20' do
            expect_any_instance_of(Die).to receive(:roll).and_return(rand(1..20))
            event.perform
        end
        
        it 'is successful when the attacker\'s roll is >= the defenders armor class' do
            allow_any_instance_of(Die).to receive(:roll).and_return(11)
            expect(event.success?).to eq true      
        end
        
        it 'is not successful when the attacker\'s roll is < the defenders armor class' do
            allow_any_instance_of(Die).to receive(:roll).and_return(9)
            expect(event.success?).to eq false
        end
        
        context 'when defenders armor class is > 20' do
            let(:defender) { Character.new(armor_class: 21) }
            let(:event) { AttackEvent.new(attacker: attacker, defender: defender) }
            
            it 'is successful when the attacker\'s roll is 20' do
                allow_any_instance_of(Die).to receive(:roll).and_return(20)
                expect(event.success?).to eq true
            end
        end

        context 'when attack is successful' do
            it 'reduces the defender\'s hit points by attacker\'s damage' do
                allow_any_instance_of(Die).to receive(:roll).and_return(11)
                allow(attacker).to receive(:damage).and_return 2
                expect { event.perform }.to change { defender.hit_points }.by -2
            end

            it 'increase the attacker\'s experience by 10' do
                allow_any_instance_of(Die).to receive(:roll).and_return(11)
                expect { event.perform }.to change { attacker.experience }.by 10
            end
            
            context 'and roll is natural 20' do
                it 'reduces the defender\'s hit points by double' do
                    allow_any_instance_of(Die).to receive(:roll).and_return(20)
                    allow(attacker).to receive(:damage).and_return 2
                    expect { event.perform }.to change { defender.hit_points }.by -4
                end
            end

            context 'when defender is on the brink of death' do
                it 'causes the defender to die when hit points are <= 0' do
                    allow_any_instance_of(Die).to receive(:roll).and_return(11)
                    defender.hit_points= 1
                    event.perform
                    expect(defender.is_dead?).to eq true
                end
            end
            
            context 'when defender is healthy' do
                it 'doe not cause the defender to die when hit points are > 0' do
                    allow_any_instance_of(Die).to receive(:roll).and_return(11)
                    defender.hit_points= 10
                    event.perform
                    expect(defender.is_dead?).to eq false
                end
            end
        end
    end

end