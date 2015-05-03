require "mongoid/auto_increment_id/config"

module Mongoid
  class Identity
    MAII_TABLE_NAME = "mongoid.auto_increment_ids".freeze

    # Generate auto increment id
    # params:
    def self.generate_id(document)
      if Mongoid::AutoIncrementId.cache_enabled?
        cache_key = self.maii_cache_key(document)
        if ids = Mongoid::AutoIncrementId.cache_store.read(cache_key)
          cached_id = self.shift_id(ids, cache_key)
          return cached_id if !cached_id.blank?
        end
      end

      database_name = Mongoid::Sessions.default.send(:current_database).name

      o = nil
      Mongoid::Sessions.default.cluster.with_primary do |node|
        opts = {
          findAndModify: MAII_TABLE_NAME,
          query: { _id: document.collection_name },
          update: { "$inc" => { c: Mongoid::AutoIncrementId.seq_cache_size } },
          upsert: true,
          new: true
        }
        o = node.command(database_name, opts, {})
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
    ID_FIELD = '_id'.freeze

    def self.included(base)
      base.class_eval do
        # define Integer for id field
        Mongoid.register_model(self)
        field :_id, type: Integer, overwrite: true
      end
    end

    # hack id nil when Document.new
    def identify
      Identity.new(self).create
      nil
    end

    alias_method :super_as_document, :as_document
    def as_document
      result = super_as_document
      if result[ID_FIELD].blank?
        result[ID_FIELD] = Identity.generate_id(self)
      end
      result
    end
  end
end
