module Mongoid
  class Identity
    # Generate auto increment id
    def self.generate_id(document)
      database_name = Mongoid::Sessions.default.send(:current_database).name

      o = nil
      Mongoid::Sessions.default.cluster.with_primary do |node| 
         o = node.command(database_name, 
                      {"findAndModify" => "mongoid.auto_increment_ids",  
                       :query  => { :_id => document.collection_name }, 
                       :update => { "$inc" => { :c => 1 }}, 
                       :upsert => true, 
                       :new => true }, {})
      end

      o["value"]["c"].to_i
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
