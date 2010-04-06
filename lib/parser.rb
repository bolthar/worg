
class GemData

  def initialize(name, authors)
    @name    = name
    @authors = authors
  end

  def to_s
    return "#{@name}: #{@authors}"
  end

  def matches?(name)    
    return @authors.any? do |author|      
      author.split(" ")[0].to_s.upcase == name.strip
    end
  end

end

gems = []

File.open(File.join(File.dirname(__FILE__), "results"),'r') do |file|
  file.lines.each do |line|
    name    = line.split("|")[0]
    authors = []
    line.split("|")[1].split(",").each do |author|
      authors << author.delete("\"").delete("\n").strip
    end
    gems << GemData.new(name, authors)
  end
end

male_names = File.open(File.join(File.dirname(__FILE__), "male_names.csv"),'r').lines.to_a

gems_by_males = gems.select { |gem| male_names.any? { |name| gem.matches?(name) }}
gems_by_males.each do |gem|
  p gem.to_s
end

p gems_by_males.length

female_names = File.open(File.join(File.dirname(__FILE__), "female_names.csv"),'r').lines.to_a

gems_by_females = gems.select { |gem| female_names.any? { |name| gem.matches?(name) }}
gems_by_females.each do |gem|
  p gem.to_s
end

p gems_by_females.length