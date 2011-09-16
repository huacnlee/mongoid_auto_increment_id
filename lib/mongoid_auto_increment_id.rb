module Mongoid
  class Counter
    include Components
  end
  
  class Identity    
    protected
      def generate_id
        table_name = @document.class.to_s.tableize
        o = Counter.collection.find_and_modify({:query => {:_id => table_name},
                                            :update => {:$inc => {:c => 1}}, 
                                            :new => true, 
                                            :upsert => true})
        o["c"]
      end
  end
  
  module Document    
    def identify
    end
    
    def as_document
      if attributes["_id"].blank?
        attributes["_id"] = Identity.new(self).create
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
