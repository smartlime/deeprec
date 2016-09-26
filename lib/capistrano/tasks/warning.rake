namespace :deploy do
  task :warning do
    fetch :branch
    puts
    puts "╔#{'═' * 78}╗"
    ['', '!!!! YOU ARE ABOUT TO DEPLOY APPLICATION !!!!', '',
     'Please, check config:', ''].each { |s| puts "║#{s.center(78).white}║" }
    [:stage, :branch].each do |v|
      puts "║#{v.to_s.rjust(16).white}: #{fetch(v).to_s.ljust(60).colorize([:production, 'master'].include?(fetch(v)) ?
                                                                               :light_red : :light_green)}║"
    end
    puts "║#{' ' * 78}║"
    puts "╚#{'═' * 78}╝"
    puts
    print 'Press ^C to ABORT in '.red
    5.times { |n| print " #{5 - n} sec...".red; sleep(1) }
    print "\r#{' ' * 80}\r"
    puts 'OK, go on:'.white
    puts
  end

  before 'deploy', 'deploy:warning'
end
