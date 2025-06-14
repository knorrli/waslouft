module Scrapers
  class All
    def self.scrapers
      @scrapers ||= {}
    end

    def self.run
      scrapers.values.each(&:call)
    end
  end
end
