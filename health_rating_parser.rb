require 'rubygems'
require 'csv'
require 'smarter_csv'
require 'mongo'
include Mongo

puts Dir.pwd

def database_connection
	client = MongoClient.new # defaults to localhost:27017 db = client[‘example-db’] coll = db[‘example-collection’]
	db   = client.db 'health' 
	db.drop_collection 'ratings'
	ratings_coll = db.create_collection 'ratings'
end

def parse_ratings_csv
	ratings_file = File.new("ratings.csv", "w+")

	# iconv -f ISO-8859-1 -t utf-8 WebExtract.txt > Modified.txt
	File.foreach('WebExtract.txt')  {
		|f| newf = f.force_encoding('UTF-8').encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub(/\"/,'""')
		ratings_file.puts newf
	}
	ratings_file.rewind

	# load data to Mongo
	begin
		all_ratings = SmarterCSV.process(ratings_file, col_sep: '"",')
		# puts all_ratings.class Array
		all_ratings.each{ |x| ratings_coll.insert x } # insert into mongo
		puts all_ratings[5001]
	rescue EOFError
		p 'got an error'
	end
	ratings_file.close
	p "done loading data"
end

# Usage
database_connection()
parse_ratings_csv()