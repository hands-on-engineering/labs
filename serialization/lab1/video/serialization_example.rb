class Datapoint
  def initialize(value)
    @sensor_reading = value
  end
end

# this is the object we want to serialize
my_datapoint = Datapoint.new("GPGGA")
puts "my_datapoint is #{my_datapoint.inspect}"
puts

# let's serialize my_datapoint
serialized_string = Marshal.dump(my_datapoint)
puts "The serialized datapoint is:  #{serialized_string.inspect}"
puts

# now let's deserialize that same object using the serialized string 
deserialized_datapoint = Marshal.load(serialized_string)
puts "deserialized_datapoint is #{deserialized_datapoint.inspect}" 
