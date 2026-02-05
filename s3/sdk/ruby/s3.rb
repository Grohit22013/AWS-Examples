require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

# Read environment variables
bucket_name = ENV['BUCKET_NAME']
region = ENV['AWS_REGION'] || 'us-east-1'

puts "Bucket name: #{bucket_name}"
puts "Region: #{region}"

# Create S3 client
s3 = Aws::S3::Client.new(region: region)

# Create bucket (region-aware)
if region == 'us-east-1'
  s3.create_bucket(bucket: bucket_name)
  binding.pry
else
  s3.create_bucket(
    bucket: bucket_name,
    create_bucket_configuration: {
      location_constraint: region
    }
  )
  binding.pry
end

# Random number of files (1–6)
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

number_of_files.times do |i|
  puts "Uploading file #{i}"

  filename = "file_#{i}.txt"
  output_path = "/tmp/#{filename}"

  # Create file
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end

  # Upload to S3
  File.open(output_path, "rb") do |f|
    s3.put_object(
      bucket: bucket_name,
      key: filename,
      body: f
    )
  end
end

