class NamesListMutator
  attr_reader :fullnames
  
  def initialize(namesfile)
    @fullnames = open(namesfile, 'r').lines.map {|line| line.downcase}
  rescue => exception
    $stderr.puts exception
    exit
  end
  
  def mutate
    results = []
    
    fullnames.each do |fullname|
      names = fullname.split(' ')
      (1..names.count).each do |n|
        results << names.permutation(n).map do |p|
          yield(p)
        end
      end
    end
    
    return results
  end
end

list = []
names = NamesListMutator.new('names.txt')
list << names.mutate {|x| x.join('.')}
list << names.mutate {|x| x.join('')}
list << names.mutate {|x| x.join('-')}
list << names.mutate {|x| x.map{|name| name[0]}.join('')} 

list << names.mutate do |x|
  x.inject(x.last) do |accum,item| 
    if accum.include?(item)
      accum
    else
      item[0] + accum 
    end
  end
end

list.flatten!.sort!.uniq!
puts list