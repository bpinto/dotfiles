Pry.start || exit rescue LoadError

def self.silence_active_record
  if defined? ActiveRecord
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
  end

  result = yield

  ActiveRecord::Base.logger = old_logger if old_logger

  result
end

def self.benchmark(count = 1)
  require 'benchmark'

  result = nil

  silence_active_record do
    Benchmark.bmbm do |benchmark|
      benchmark.report { count.times { result = yield } }
    end
  end

  result
end
