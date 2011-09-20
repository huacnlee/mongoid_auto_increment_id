module Mongoid  
  class Identity        
    def generate_id
      counter = Mongoid.master.collection("mongoid.auto_increment_ids")
      table_name = @document.class.to_s.tableize
      o = counter.find_and_modify({:query => {:_id => table_name},
                                          :update => {:$inc => {:c => 1}}, 
                                          :new => true, 
                                          :upsert => true})
      o["c"].to_s
    end
  end
  
  module Document  
    included do
      identity :type => String
    end

    def identify
    end
    
    alias_method :super_as_document,:as_document
    def as_document
      result = super_as_document
      if result["_id"].blank?
        result["_id"] = Identity.new(self).generate_id
      end
      result
    end
  end
  
  module Extensions #:nodoc:
    module ObjectId #:nodoc:
      module Conversions
        def convert(klass, args, reject_blank = true)
          case args
          when ::Array
            args.delete_if { |arg| arg.blank? } if reject_blank
            args.replace(args.map { |arg| convert(klass, arg, reject_blank) })
          when ::Hash
            args.tap do |hash|
              hash.each_pair do |key, value|
                next unless klass.object_id_field?(key)
                begin
                  hash[key] = convert(klass, value, reject_blank)
                rescue BSON::InvalidObjectId; end
              end
            end
          else
            args.to_s
          end
        end
      end
    end
  end
end
