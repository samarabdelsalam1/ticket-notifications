RSpec.configure do |config|
  config.around(:each) do |example|
    Timecop.safe_mode = true
    Timecop.freeze(Time.current) do
      example.run
    end
  end
end