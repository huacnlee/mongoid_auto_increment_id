require "mongoid"
require 'active_support/all'
require 'mongoid/auto_increment_id/config'
require 'mongoid/auto_increment_id/version'

module Mongoid
  class Identity
    MAII_TABLE_NAME = 'mongoid.auto_increment_ids'.freeze

    class << self

      # Generate auto increment id
      # params:
      def generate_id(document)
        if AutoIncrementId.cache_enabled?
          cache_key = self.maii_cache_key(document)
          if ids = Mongoid::AutoIncrementId.cache_store.read(cache_key)
            cached_id = self.shift_id(ids, cache_key)
            return cached_id if !cached_id.blank?
          end
        end

        opts = {
          findAndModify: MAII_TABLE_NAME,
          query: { _id: document.collection_name },
          update: { '$inc' => { c: AutoIncrementId.seq_cache_size } },
          upsert: true,
          new: true
        }
        o = Mongoid.default_client.database.command(opts, {})

        last_seq = o.documents[0]['value']['c'].to_i

        if AutoIncrementId.cache_enabled?
          ids = ((last_seq - AutoIncrementId.seq_cache_size) + 1 .. last_seq).to_a
          self.shift_id(ids, cache_key)
        else
          last_seq
        end
      end

      def shift_id(ids, cache_key)
        return nil if ids.blank?
        first_id = ids.shift
        AutoIncrementId.cache_store.write(cache_key, ids)
        first_id
      end

      def maii_cache_key(document)
        "maii-seqs-#{document.collection_name}"
      end
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
