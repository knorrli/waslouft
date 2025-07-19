module Scrapers
  module Registerable
    extend ActiveSupport::Concern

    class_methods do
      def inherited(child_class)
        All.scrapers[child_class.name.demodulize] = child_class
      end
    end
  end
end
