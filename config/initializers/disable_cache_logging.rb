# frozen_string_literal: true
# Get rid of cache logging
module ActionController
  class LogSubscriber < ActiveSupport::LogSubscriber
    %w(write_fragment read_fragment exist_fragment?
       expire_fragment expire_page write_page).each do |method|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{method}(event)
          return
        end
      METHOD
    end
  end
end
