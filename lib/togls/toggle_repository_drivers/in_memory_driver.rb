require 'thread'

module Togls
  module ToggleRepositoryDrivers
    # Toggle Repositoy In-Memory Driver
    #
    # The Toggle Repository In-Memory Driver provides the interface to store and
    # retrieve toggles from the in-memory store.
    class InMemoryDriver
      def initialize
        @toggles = {}
        @toggles_lock = Mutex.new
      end

      def store(toggle_id, toggle_data)
        @toggles_lock.synchronize do
          @toggles[toggle_id] = toggle_data
        end
      end

      def get(toggle_id)
        @toggles_lock.synchronize do
          @toggles[toggle_id]
        end
      end

      def all
        @toggles_lock.synchronize do
          @toggles
        end
      end
    end
  end
end
