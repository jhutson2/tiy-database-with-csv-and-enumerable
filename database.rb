require 'csv'

class DataEngine
  def initialize
    @people = []

    CSV.foreach("people.csv", headers:true) do |person|
      name = person["name"]
      address = person["address"]
      position = person["position"]
      phone_number = person["phone"]
      salary = person["salary"]
      slack_account = person["slack"]
      github_account = person["github"]

      add_to_data(name, address, position, phone_number, salary, slack_account, github_account)

    end
  end

  def save_people
    csv = CSV.open("people.csv", "w")
    csv.add_row %w{name address position phone salary slack github}

    @people.each do |person|
      csv.add_row [person.name, person.address, person.position, person.phone_number, person.salary, person.slack_account, person.github_account]
    end
    csv.close
  end

  def add_to_data (name, address, position, phone_number, salary, slack_account, github_account)
    person = Person.new(name)
    person.address = address
    person.position = position
    person.phone_number = phone_number
    person.salary = salary
    person.slack_account = slack_account
    person.github_account = github_account
    @people << person
  end

  def search(name)
    found_people = @people.select { |person| person.name == name}
    found_people = @people.each do |person|
      puts person.name
      puts person.address
      puts person.position
      puts person.phone_number
      puts person.salary
      puts person.slack_account
      puts person.github_account
    end
    return found_people
  end

  def delete(name)
    delete_people = @people.delete_if { |person| person == name}

  end

  def banner (message)
    puts "*" * (4 + message.length)
    puts "* #{message} *"
    puts "*" * (4 + message.length)
  end

  def prompt_for_search
    puts
    puts "Who would you like to search for in the database?"
    puts
    search_name = gets.chomp
    matches = @people.select { |person| person.name == search_name }

    if matches.empty?
      puts
      puts "Sorry, that person doesn't party with us!"
    end

    matches.each do |person|
      puts
      puts "Found the life of the party!"
      puts
      puts "address"
      puts person.address
      puts
      puts "phone number"
      puts person.phone_number
      puts
      puts "position"
      puts person.position
      puts
      puts "salary"
      puts person.salary
      puts
      puts "slack account"
      puts person.slack_account
      puts
      puts "github account"
      puts person.github_account
      puts
    end
  end

  def prompt_for_add
    puts
    puts "Who would you like to add to the database?"
    puts
    name = gets.chomp
    matches = @people.select { |person| person.name == name }

    if matches.any?
      puts
      puts "Sorry, that person is already in the party"
    end
    person = Person.new(name)
    puts
    puts "What is #{name}'s address?"
    puts
    person.address = gets.chomp
    puts
    puts "What is #{name}'s phone number?"
    puts
    person.phone_number = gets.chomp
    puts "What is #{name}'s position?"
    puts
    person.position = gets.chomp
    puts
    puts "What is #{name}'s salary?"
    puts
    person.salary = gets.chomp
    puts
    puts "What is #{name}'s slack account"
    puts
    person.slack_account = gets.chomp
    puts
    puts "What is #{name}'s github account?"
    puts
    person.github_account = gets.chomp

    @people << person
    save_people
  end

  def prompt_for_delete
    puts
    puts "Who do you wish to delete from database?"
    puts
    delete_name = gets.chomp
    matches = @people.select { |person| person.name == delete_name }
    if matches.empty?
      puts
      puts "Sorry, that person doesn't party with us!"
    end

    if delete_name == matches.any?
      puts
      puts "Found the party pooper, removing #{person.name} from the party!"
      puts
      @people.delete(person)
      end
    save_people
  end

  def menu
    loop do
      puts "Welcome to The Iron Yard database! There are #{@people.length} people in this database"
      answer = gets.chomp
      case answer
      when "D", "Delete"
        prompt_for_delete
        when "A", "Add"
          prompt_for_add
        when "S", "Search"
          prompt_for_search
        else
          puts "I didn't quite understand your request"
      end
    end
  end
end

class Person
  attr_accessor :name, :address, :position, :phone_number, :salary, :slack_account, :github_account

  def initialize(name)
    @name = name
  end
end

my_database = DataEngine.new
my_database.menu
