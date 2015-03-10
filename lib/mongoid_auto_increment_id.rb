require "mongoid/auto_increment_id/config"

module Mongoid
  class Identity
    # Generate auto increment id
    # params:
    def self.generate_id(document)
      cache_key = self.maii_cache_key(document)
      if Mongoid::AutoIncrementId.cache_enabled?
        if ids = Mongoid::AutoIncrementId.cache_store.read(cache_key)
          cached_id = self.shift_id(ids, cache_key)
          return cached_id if !cached_id.blank?
        end
      end
      
      database_name = Mongoid::Sessions.default.send(:current_database).name

      o = nil
      Mongoid::Sessions.default.cluster.with_primary do |node| 
         o = node.command(database_name, 
                      {"findAndModify" => "mongoid.auto_increment_ids",  
                       :query  => { :_id => document.collection_name }, 
                       :update => { "$inc" => { :c => Mongoid::AutoIncrementId.seq_cache_size }}, 
                       :upsert => true, 
                       :new => true }, {})
      end
      
      last_seq = o["value"]["c"].to_i
      
      if Mongoid::AutoIncrementId.cache_enabled?
        ids = ((last_seq - Mongoid::AutoIncrementId.seq_cache_size) + 1 .. last_seq).to_a
        self.shift_id(ids, cache_key)
      else
        last_seq
      end
    end
    
    
    private
    def self.shift_id(ids, cache_key)
      return nil if ids.blank?
      first_id = ids.shift
      Mongoid::AutoIncrementId.cache_store.write(cache_key, ids)
      first_id 
    end
    
    def self.maii_cache_key(document)
      "maii-seqs-#{document.collection_name}"
    end
  end

  module Document
    def self.included(base)
      base.class_eval do
        # define Integer for id field
        Mongoid.register_model(self)
        field :_id, :type => Integer, :overwrite => true
      end
    end

    # hack id nil when Document.new
    def identify
      Identity.new(self).create
      nil
    end

    alias_method :super_as_document,:as_document
    def as_document
      result = super_as_document
      if result["_id"].blank?
        result["_id"] = Identity.generate_id(self)
      end
      result
    end
  end
end
