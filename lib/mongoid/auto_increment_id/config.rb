module Mongoid
  module AutoIncrementId
    @seq_cache_size = 1
    @cache_store = ActiveSupport::Cache::MemoryStore.new
    
    class << self
      # How many ids generate in once call, and it will cache ids in Memroy, to reduce MongoDB write
      # default: 1
      #
      # [Call first] -> [occupancy N and Write MongoDB] -> [Save N ids in Memory variable `aii_cache`] 
      # [Next call] -> [Shift aii_cache and return]
      # .....
      # [N+1 call] -> [occupancy N and Write MongoDB] -> [Save N ids in Memory variable `aii_cache`] 
      attr_accessor :seq_cache_size
      
      # ActiveSupport::Cache::Store
      # default: ActiveSupport::Cache.lookup_store(:memory_store)
      #
      # Mongoid::AutoIncrementId.cache_store = ActiveSupport::Cache.lookup_store(:memcache_store, "127.0.0.1")
      # For cache ids
      attr_accessor :cache_store
      
      def cache_enabled?
        self.seq_cache_size > 1
      end
    end
  end
end