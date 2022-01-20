class Event
    attr_accessor :result

    def perform
        raise_if_performed

        self.result= true
    end

    def raise_if_performed
        raise "this is event has already happened. you can undo its effect with .undo" if self.done?
    end

    def result=(value)
        @result ||= value
    end

    def success?
        self.perform if !self.done?
        @result
    end

    def done?
        !@result.nil?
    end

end