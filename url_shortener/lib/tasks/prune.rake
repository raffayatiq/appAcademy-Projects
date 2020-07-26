namespace :prune do
	desc "Prune stale URLs from shortened_urls table, along with associated records from visits and taggings table"
	task :prune_urls => :environment do
		n = ENV['minutes'].to_i || 144
		puts "Pruning stale URLs..."
		ShortenedUrl.prune(n)
	end
end