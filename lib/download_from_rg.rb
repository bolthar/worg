
require 'rubygems'
require 'mechanize'

agent = Mechanize.new


data = []

('A'..'Z').each do |letter|
  page_count = 1
  while page_count != 0
    print "letter: #{letter}, page: #{page_count}\n"
    begin
    agent.get("http://rubygems.org/gems?letter=#{letter}&page=#{page_count}") do |page|
      threads = []
      gems = page.search("//div[@class='gems border']/ol/li/a")
      page_count = -1 if gems.length == 0
      gems.each do |link|
        threads << Thread.new do
          agent.get(link['href']) do |gem|
            struct = {}
            gem.search("//div[@class='authors']/p").each do |author|
              struct[:author] = author.inner_html
            end
            struct[:gem] = gem.title.split("|")[0]
            data << struct
          end
        end
        threads.map { |t| t.join }
      end
    end
    page_count += 1
    rescue Exception => ex
      page_count += 1
      p ex
    end
  end  
end

File.open(File.join(File.dirname(__FILE__), "results"), 'w+') do |file|
  data.each do |auth|
    file << "#{auth[:gem]}|#{auth[:author]}\n"
  end
end
