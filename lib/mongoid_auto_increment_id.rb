module Mongoid
  class Counter
    include Components
  end
  
  class Identity        
    def generate_id
      table_name = @document.class.to_s.tableize
      o = Counter.collection.find_and_modify({:query => {:_id => table_name},
                                          :update => {:$inc => {:c => 1}}, 
                                          :new => true, 
                                          :upsert => true})
      Criterion::Unconvertable.new(o["c"].to_s)
    end
  end
  
  module Document  
    included do
      identity :type => String
    end
        
    def identify
    end
    
    def as_document
      if attributes["_id"].blank?
        attributes["_id"] = Identity.new(self).generate_id
      end
      attributes.tap do |attrs|
        relations.each_pair do |name, meta|
          if meta.embedded?
            relation = send(name)
            attrs[name] = relation.as_document unless relation.blank?
          end
        end
      end
    end
  end
end
