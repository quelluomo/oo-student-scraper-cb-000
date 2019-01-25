require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    page = Nokogiri::HTML(html)
    students = []
    page.css("div.student-card").each do |student_card|
      student_cards = {}
      student_cards[:name] = student_card.css("h4.student-name").text
      student_cards[:location] = student_card.css("p.student-location").text
      student_cards[:profile_url] = student_card.css("a").attribute("href").value
      students << student_cards
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    page = Nokogiri::HTML(html)
    profile = {}

    social = page.css("div.social-icon-container a")
      social.each do |social|
        link = social.attribute("href").value
        if link.include?("twitter")
          profile[:twitter] = link
        elsif link.include?("linkedin")
          profile[:linkedin] = link
        elsif link.include?("github")
          profile[:github] = link
        else
          profile[:blog] = link
        end
      end 
      profile[:profile_quote] = page.css("div.profile-quote").text
      profile[:bio] = page.css("div.description-holder p").text
  profile
  #binding.pry
  end
end
