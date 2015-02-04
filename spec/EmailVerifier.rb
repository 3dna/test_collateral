require 'yaml'
require 'nationbuilder'
require 'pry'
 
describe "Email API integration Tests" do
  
  def extract_value(result, expected_position)
    expected_position.each do |x|
      result = result[x]
    end
    result
  end

 	it 'API call for email' do
		parsed = begin
  		YAML.load(File.open("spec/TestCases.yml"))
			rescue ArgumentError => e
  			puts "Could not parse YAML: #{e.message}"
		end
    
    parsed.each do |k, v|
			slug = v['slug']
			token = v['token']
			endpoint = v['endpoint']
			method = v['method']
			params = v['params']
      expected_position = v['expected_position']
      expected_value = v['expected_value']
      
      # its not a symbol when it comes out of the yml file
      params = params.map{|k,v| {k.to_sym => v} }.first
			client = NationBuilder::Client.new(slug, token)

      result = client.call(endpoint.to_sym, method.to_sym, params)
			actual_value = extract_value result, expected_position
      puts actual_value
      puts expected_value
		end 
	
  end
end