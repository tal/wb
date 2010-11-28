class Sequel::Model
  # extend Forwardable
  
  def sql_literal(dataset=nil)
    self.pk
  end
  
  def validates_relation *cols
    cols.each do |col|
      rel = col.to_s.gsub(/_id$/,'')
      errors.add(col, "of #{values[col].inspect} does not exist") unless rel.classify.constantize.exists?(values[col])
    end
  end
  
  class << self
    def forward_method pre, *meths
      meths.each do |meth|
        
        define_method :"#{pre}_#{meth}" do |*clear|
          obj = __send__(pre,*clear)
          
          obj.try(meth)
        end
      end # /each
    end
    
    def exists? i
      !!self[i]
    end
  end
  
end