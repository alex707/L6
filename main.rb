load './InstanceCounter.rb'
load './Company.rb'
load './Station.rb'
load './Route.rb'
load './Train.rb'
load './PassengerTrain.rb'
load './CargoTrain.rb'
load './Car.rb'
load './PassengerCar.rb'
load './CargoCar.rb'

choise = ''

menu_text = <<-'MENU_TEXT'
Choose action:
  1   - Create station
  2   - Create train
  3   - Create route
  4   - Add station to route
  5   - Remove station from route
  6   - Set route to train
  7   - Add cars to train
  8   - Remove cars from train
  9   - Move train forward
  10  - Move train backward
  11  - Display stations list
  12  - Display trains list
  13  - Display routes list
(Enter 'stop' for exit)
MENU_TEXT


stations  = []
trains    = []
routes    = []
cars      = []

while choise != 'stop' do
  begin

    puts menu_text
    print 'Your choise: '
    choise = gets.chomp
    puts


    case choise
    when 'stop'
      puts 'Exiting...'
      next

    when '1'
      puts 'Enter station name: '
      name = gets.chomp
      stations << Station.new(name)

    when '2'
      print 'Enter train number: '
      number  = gets.chomp
      print "Enter train type ('pass' or 'cargo'): "
      type  = gets.chomp

      case type
      when 'pass'
        trains << PassengerTrain.new(number, type)
      when 'cargo'
        trains << CargoTrain.new(number, type)
      else
        puts "Type must be 'pass' or 'cargo'. Please, repeat saving of the train."
      end

    when '3'
      print 'Enter begin station name (from existing stations): '
      name_1 = gets.chomp
      print 'Enter end station name (from existing stations): '
      name_2 = gets.chomp

      st_1 = stations.select { |st| st.name == name_1 }.first
      st_2 = stations.select { |st| st.name == name_2 }.first

      if st_1 && st_2 
        routes << Route.new(st_1, st_2)
        puts "Route created succesfull."
      else
        puts 'Bad station name. Check stations(see p. 11). Route was not created.'
      end

    when '4'
      print 'Enter begin station name (first station of route): '
      name_1 = gets.chomp
      print 'Enter end station name (last station of route): '
      name_2 = gets.chomp

      route = routes.select { |r| r.st_begin.name == name_1 && r.st_end.name == name_2 }.first
      if route
        print 'Enter station name to add (from existing): '
        name_3 = gets.chomp

        station = stations.select { |s| s.name == name_3 }.first
        if station
          route.add_station station
          puts 'Station was added to route'
        else
          puts 'Station for add not found. check station list (see p. 11)'
        end
      else
        puts 'Route not found.'
      end

    when '5'
      print 'Enter begin station name (first station of route): '
      name_1 = gets.chomp
      print 'Enter end station name (last station of route): '
      name_2 = gets.chomp

      route = routes.select { |r| r.st_begin.name == name_1 && r.st_end.name == name_2 }.first
      if route
        print 'Enter station name to remove (from existing in route list): '
        name_3 = gets.chomp

        station = route.intermediate.select { |s| s.name == name_3 }.first
        if station
          route.delete_station(name_3)
          puts 'Station was removed from route'
        else
          puts 'Station for remove not found. check station list in route(see p. 13)'
        end
      else
        puts 'Route not found.'
      end

    when '6'
      print 'Enter train number for setting route: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        print 'Enter begin station name (first station of route): '
        name_1 = gets.chomp
        print 'Enter end station name (last station of route): '
        name_2 = gets.chomp

        route = routes.select { |r| r.st_begin.name == name_1 && r.st_end.name == name_2 }.first
        if route
          train.route = route
          puts 'Route entered.'
        else
          puts 'Route not found.'
        end
      else
        puts 'Train not found.'
      end

    when '7'
      print 'Enter train number to add cars: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        train.type == 'pass' ? train.car_connect(c = PassengerCar.new) : train.car_connect(c = CargoCar.new)
        cars << c
        puts 'Car added.'
      else
        puts 'Train not found.'
      end

    when '8'
      print 'Enter train number to remove cars: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.cars_count == 0
          puts 'Can not to remove cars: cars count is zero.'
        else
          train.car_disconnect
          puts 'Car removed.'
        end
      else
        puts 'Train not found.'
      end

    when '9'
      print 'Enter train number to move next station: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.route
          train.go_to_next_st
          puts 'Train moved.'
        else
          puts 'Can not move train: set route.'
        end
      else
        puts 'Train not found.'
      end

    when '10'
      print 'Enter train number to move next station: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.route
          train.go_to_prev_st
          puts 'Train moved.'
        else
          puts 'Can not move train: set route.'
        end
      else
        puts 'Train not found.'
      end

    when '11'
      puts "Station name  trains"
      stations.each do |st|
        puts "  #{st.name.rjust(10, ' ')}  #{st.trains.map(&:number).join(', ')}"
      end

    when '12'
      puts "Number       Type     Cars    Company name    Route"
      trains.each do |t|
        rr = ''
        unless t.route.nil?
          rr = "#{t.route.st_begin.name}-#{t.route.st_end.name}"
        end
        puts "#{t.number.to_s.rjust(9, ' ')}" \
          "#{t.type.rjust(8, ' ')}" \
          "#{t.cars_count.to_s.rjust(9, ' ')}" \
          "#{t.company_name.to_s.rjust(17, ' ')}     " \
          "#{rr}"
      end

    when '13'
      puts "Route name            stations"
      routes.each do |r|
        puts "#{(r.st_begin.name+'-'+r.st_end.name).rjust(20, ' ')}  " \
          "#{r.intermediate.map(&:name).join(', ')}"
      end

    when '14'
      print 'Enter train number to set company name: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        print 'Enter company name: '
        c_name = gets.to_s
        train.company_name = c_name
      else
        puts 'Train not found.'
      end

    when '15'
      print 'All: '
      puts Station.all.map(&:name).join(', ')

    when '16'
      print 'Enter train number: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train.nil?
        puts 'Train not found.'
      else
        rr = ''
        unless train.route.nil?
          rr = "#{train.route.st_begin.name}-#{train.route.st_end.name}"
        end

        puts "#{train.number} " \
          "#{train.type} " \
          "#{train.cars_count}" \
          "#{train.company_name} " \
          "#{rr}"
      end

    when '17'
      puts "-#{Train.instances}/#{Station.instances}/#{Route.instances}-"

    when '18'
      puts cars.map { |c| "#{c.object_id.to_s.rjust(15, ' ')}  #{c.status}" }

    else

    end

  rescue RuntimeError => e
    puts e.message
    puts 'Retry you choise with correct data.'
  rescue => e
    puts e
    puts e.backtrace
    break
  end


  puts
end

