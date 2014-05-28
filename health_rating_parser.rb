require 'rubygems'
require 'csv'
require 'smarter_csv'

puts Dir.pwd

# iconv -f ISO-8859-1 -t utf-8 WebExtract.txt > Modified.txt
out_file = File.new("out.csv", "w+")
File.foreach('WebExtract.txt')  {
	|f| 
	newf = f.force_encoding('UTF-8').encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub(/\"/,'""')
	out_file.puts newf
}
out_file.rewind

begin
	pets_by_owner = SmarterCSV.process(out_file, col_sep: '""')
	puts pets_by_owner.class 
	puts pets_by_owner[0]
	puts pets_by_owner[5001]
rescue EOFError
	puts 'got an error'
end

