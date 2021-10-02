require "json"
require "tty-prompt"

module VinylSection
  include Cart

  def decide_whether_to_add_to_cart
    if PROMPT.yes?("Should I add anything?".green)
      add_items_to_cart
    else
      system 'clear'
      display_menu
    end
  end

  def display_filtered_records(record)
    puts "CATALOGUE #: #{record["Catno"]}\n"+
    "ALBUM: #{record["Album"]}\n" +
    "ARTIST: #{record["Artist"]}\n" +
    "YEAR: #{record["Year"]}\n" +
    "GENRE: #{record["Genre"]}\n" +
    "SUBGENRE: #{record["Subgenre"]}\n" +
    "PRICE $#{record["Price"]}\n" +
    "=========================="
  end

  def search_by_keyword(tag, tag_2 = nil)
    found = false
    while !found
      puts "What #{tag.downcase} are you looking for?"
      keyword = gets.split.map(&:capitalize).join(' ').chomp # match the data to the format of the json
      system 'clear'
      if keyword == "" 
        puts "[No results. Woops, guess I should actually search for something..]".italic.red
        next
      end
      for record in STOCK
        if (tag_2 == nil && (record[tag] == keyword || record[tag].include?(keyword))) || (tag_2 != nil && record[tag_2].include?(keyword))
        display_filtered_records(record) 
          found = true 
        end
        
      end
      if !found
      puts "[No results found... maybe I should try and simplify my search?)]\n".italic.magenta + "HINT: 'beach' will return The Beach Boys\n'rock' will return Psychedelic Rock, Hard Rock, Rockabilly etc,\n'bob' will return Bob Dylan, Bob Marley etc."
      display_menu
      else 
        decide_whether_to_add_to_cart
      end
    end
  end

  def search_by_price(max)
    found = false
  while !found
    puts "Whats the max you're willing to pay for a record?"
    price = gets.to_i
    system 'clear'
    if (..40).include?(price)
      puts "[What was I thinking, I haven't seen a single record here for less than ".italic + "40 bucks. ".magenta.italic + "Guess I've gotta stretch the purse strings... :'( ]".italic
    end
    for record in STOCK
      if record["Price"] <= price
          display_filtered_records(record)
          found = true
      end
    end
  end
  decide_whether_to_add_to_cart
end

  def filter_records(filter_choice)
    system("clear")
    case filter_choice
    # BY GENRE **********
    when 1
    search_by_keyword("Genre", "Subgenre")
    when 2
    search_by_keyword("Artist")
    when 3
    search_by_keyword("Album")
    when 4 
    search_by_price("Price")
    # LOOK AROUND THE STORE **********
    when 5
      look_around
    end
  end

  def display_menu
    input = PROMPT.select("There are literally hundreds of records staring at you in the face. You ponder what to do:".red) do |menu|
      menu.choice "Look for a specific GENRE", 1
      menu.choice "Look for a specific ARTIST", 2
      menu.choice "Look for a specific ALBUM", 3
      menu.choice "Set a maximum PRICE", 4
      menu.choice "Go back", 5
    end
    filter_records(input)
  end

end
