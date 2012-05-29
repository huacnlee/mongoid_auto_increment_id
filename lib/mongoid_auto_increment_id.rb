module Mongoid
  class Identity
    # Generate auto increment id
    def self.generate_id(document)
      o = Mongoid::Sessions.default.command({:findAndModify => "mongoid.auto_increment_ids",
                                             :query  => { :_id => document.collection_name },
                                             :update => { "$inc" => { :c => 1 } },
                                             :upsert => true,
                                             :new    => true })
      o["value"]["c"]
    end
  end

  module Document
    # define Integer for id field
    included do
      field :_id, :type => Integer
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
