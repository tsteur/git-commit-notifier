module GitCommitNotifier
  class DiffCallback
    attr_reader :tags

    def initialize
      @tags = []
    end

    def match(event)
      @tags << { :action => :match, :token => event.old_element }
    end

    def discard_b(event)
      @tags << { :action => :discard_b, :token => event.new_element }
    end

    def discard_a(event)
      @tags << { :action => :discard_a, :token => event.old_element }
    end

  end
end
