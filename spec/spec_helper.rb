require 'rspec'
require 'wrong/adapters/rspec'
require 'transit'

RSpec.configure do |c|
  c.alias_example_to :fit, :focus => true
  c.filter_run_including :focus => true, :focused => true
  c.run_all_when_everything_filtered = true
end

def round_trip(obj, marshaller_class)
  marshalled = marshaller_class.new.write(obj)
  marshaller_class.new.read(marshalled)
end

def should_survive_roundtrip(obj)
  [Transit::Transports::Json, Transit::Transports::MsgPack].each do |marshaller_class|
    assert { round_trip(obj, marshaller_class) == obj }
  end
end

ALPHA_NUM = 'abcdefghijklmnopABCDESFHIJKLMNOP_0123456789'

def random_alphanum
  ALPHA_NUM[rand(ALPHA_NUM.size)]
end

def random_string(max_length=10)
  l = rand(max_length-1) + 1
  (Array.new(l).map {|x| random_alphanum}).join
end

def random_symbol(max_length=10)
  random_string(max_length).to_sym
end