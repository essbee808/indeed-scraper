class Scraper
  
  BASE_PATH = "https://www.indeed.com"

  def self.scrape_index_page(input)
    html = open(BASE_PATH + "/l-#{input}-jobs.html") # interpolate input
    parsed_page = Nokogiri::HTML(html)
    all_jobs = parsed_page.css('div.jobsearch-SerpJobCard')

    all_jobs.collect do |job_card|
      job = {
        :title => job_card.css('a').attr('title').value,
        :company => job_card.css('span.company').text.strip, #remove white space
        :location => job_card.css('div.location').text,
        :job_url => job_card.css('a').attr('href').value
      }
      job
    end
  end
    
  def self.scrape_job_post(job_url)
      html = open(job_url)
      parsed_job_post = Nokogiri::HTML(html) #parse html
      other_details = parsed_job_post.css('div.jobsearch-ViewJobLayout-jobDisplay')
      
      details_hash = {}
      
      other_details.each do |info|
          details_hash[:description] = info.css('div.jobsearch-JobComponent-description p').text
          details_hash[:type] = info.css('div.jobsearch-JobMetadataHeader-item').text
      end
      details_hash
  end
end
