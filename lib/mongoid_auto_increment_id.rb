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
end
