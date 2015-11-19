require 'jumpstart_auth'
require 'bitly'

class MicroBlogger

  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
    Bitly.use_api_version_3
    @bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "Message #{message} has #{message.length - 140} too many characters and cannot be tweeted."
    end
  end

  def followers
    @client.followers.map { |f| @client.user(f).screen_name }
  end

  def dm(target, message)
     puts "Trying to send #{target} this direct message:"
     puts message
     message = "d @#{target} #{message}"
     if followers.include?(target)
       tweet(message)
     else
       puts "#{target} isn't following you, so you can't send them a direct message."
     end
  end

  def spam_my_followers(message)
    puts "Trying to spam this direct message to all your followers:"
    puts message
    followers.each do |f|
      dm(f, message)
    end
  end

  def run
    puts "Welcome to the JSL twitter client!"
    command = ""
    while command != "q"
      begin
        printf "enter command: "
        parts = gets.chomp.split
        command = parts[0]
        case command
        when "q" then puts "Goodbye!"
        when "t" then tweet(parts[1..-1].join(" "))
        when "dm" then dm(parts[1], parts[2..-1].join(" "))
        when "spam" then spam_my_followers(parts[1..-1].join(" "))
        when "elt" then everyones_last_tweet
        when "s" then shorten(parts[1])
        when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
        else
          puts "Sorry, I don't know how to #{command}."
        end
      rescue Twitter::Error::ServiceUnavailable
        puts "Service is temporarily unavailable. Try again in a minute."
      end
    end
  end

  # NOTE JSL tutorial seems to be incorrect - states that @client.friends gives an array of friend objects, but in fact it gives an array of Fixnums (IDs)
  def everyones_last_tweet
    tweets = []
    @client.friends.each do |friend|
      screen_name = @client.user(friend).screen_name
      text = @client.user(friend).status.text
      timestamp = @client.user(friend).status.created_at
      tweet = {:screen_name => screen_name, :text => text, :timestamp => timestamp}
      tweets.push(tweet)
    end
    tweets.sort_by! {|tweet| tweet[:screen_name]}
    tweets.each do |tweet|
      puts "On #{tweet[:timestamp].strftime("%A, %b %d")}, #{tweet[:screen_name]} said"
      puts tweet[:text]
      puts ""
    end
  end

  def shorten(original_url)
    puts "Shortening this URL: #{original_url}"
    @bitly.shorten(original_url).short_url
  end

end

blogger = MicroBlogger.new
blogger.run
