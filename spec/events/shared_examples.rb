shared_examples_for "an Event" do
    let(:event) { described_class.new }

    it 'stores the result of a perform call' do
        expect(event).to receive(:result=)
        event.perform
    end

    context 'while checking for success' do
        it 'returns a boolean' do
            event.perform
            expect(event.success?).to be_boolean
        end
        it 'calls perform if event has not been performed' do
            expect(event).to receive(:perform)
            event.success?
        end
        it 'does not call perform if event has been performed' do
            event.perform
            expect(event).not_to receive(:perform)
            event.success?
        end
    end

    it 'cannot be performed twice' do
        event.perform
        expect { event.perform }.to raise_error "this is event has already happened. you can undo its effect with .undo"
    end
end