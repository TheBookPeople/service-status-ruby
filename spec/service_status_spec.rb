require 'service_status/status'
require 'socket'
require 'timecop'
require 'json'

describe ServiceStatus::Status do

  before :each do
    stats = double('stats')
    allow(stats).to receive(:blocks) { '239189165' }
    allow(stats).to receive(:blocks_available) { '106180000' }
    allow(Sys::Filesystem).to receive(:stat).with('/') { stats }
    @disk_usage = '55%'

    @version = '0.0.1'
    @hostname = Socket.gethostname
    @app_name = 'killer-app'
    @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
  end

  it 'name' do
    expect(@instance.name).to eql @app_name
  end

  it 'version' do
    expect(@instance.version).to eql @version
  end

  it 'hostname' do
    expect(@instance.hostname).to eql @hostname
  end

  it 'errors' do
    expect(@instance.errors).to eql []
  end

  it 'checks' do
    expect(@instance.checks).to eql []
  end

  it 'timestamp' do
    Timecop.freeze
    @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
    timestamp =  Time.now.strftime '%Y-%m-%d %T'
    expect(@instance.timestamp).to eql timestamp
    Timecop.return
  end

  describe 'uptime' do
    it 'seconds' do
      Timecop.freeze
      @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 55)
      expect(@instance.uptime).to eql '0d:00:00:55'
      Timecop.return
    end

    it 'minutes' do
      Timecop.freeze
      @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 301)
      expect(@instance.uptime).to eql '0d:00:05:01'
      Timecop.return
    end

    it 'hours' do
      Timecop.freeze
      @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 5000)
      expect(@instance.uptime).to eql '0d:01:23:20'
      Timecop.return
    end

    it 'days' do
      Timecop.freeze
      @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 100_000)
      expect(@instance.uptime).to eql '1d:27:46:40'
      Timecop.return
    end
  end

  it 'diskusage' do
    expect(@instance.disk_usage).to eql '55%'
  end

  it 'status' do
    expect(@instance.status).to eql 'online'
  end

  it 'to_json' do
    Timecop.freeze(Time.local(2015, 04, 29, 14, 52, 47))
    @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
    expect(@instance.to_json).to eql %({"name":"#{@app_name}","version":"#{@version}","hostname":"#{@hostname}","errors":[],"stats":[],"checks":[],"timestamp":"2015-04-29 14:52:47","uptime":"0d:00:00:00","diskusage":"#{@disk_usage}","status":"online"})
    Timecop.return
  end

  describe 'add_check' do
    it 'had a check that was ok' do
      @instance.add_check('ElasticSearch', true)
      expect(@instance.checks).to eql ['ElasticSearch']
      expect(@instance.errors).to eql []
      expect(@instance.status).to eql 'online'
    end

    it 'had a check that failed' do
      @instance.add_check('ElasticSearch', false)
      expect(@instance.checks).to eql ['ElasticSearch']
      expect(@instance.errors).to eql ['ElasticSearch']
      expect(@instance.status).to eql 'offline'
    end
  end

  describe 'add_http_get_check', :vcr do
    it 'ok' do
      @instance.add_http_get_check('Responsys API', 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
      expect(@instance.checks).to eql ['Responsys API']
      expect(@instance.errors).to eql []
    end

    it 'fail' do
      @instance.add_http_get_check('Responsys API', 'https://foobar.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
      expect(@instance.checks).to eql ['Responsys API']
      expect(@instance.errors).to eql ['Responsys API']
      expect(@instance.status).to eql 'offline'
    end
  end

  describe 'add stat' do

    it 'add one' do
      @instance.add_stat('request_counts', 100, 'Number of Requests')
      expect(@instance.stats).to eql [{ description: 'Number of Requests', name: 'request_counts', value: 100 }]
    end

    it 'add multiple' do
      @instance.add_stat('request_counts', 100, 'Number of Requests')
      @instance.add_stat('error_counts', 42, 'Number of errors')
      expect(@instance.stats).to eql [
                                      { description: 'Number of Requests', name: 'request_counts', value: 100 },
                                      {:name=>"error_counts", :value=>42, :description=>"Number of errors"}
                                     ]
    end



    it 'shown in json' do
      Timecop.freeze(Time.local(2015, 04, 29, 14, 52, 47))
      @instance = ServiceStatus::Status.new(@app_name, @version, Time.now)
      @instance.add_stat('request_counts', 100, 'Number of Requests')
      expect(@instance.to_json).to eql %({"name":"#{@app_name}","version":"#{@version}","hostname":"#{@hostname}","errors":[],"stats":[{"name":"request_counts","value":100,"description":"Number of Requests"}],"checks":[],"timestamp":"2015-04-29 14:52:47","uptime":"0d:00:00:00","diskusage":"#{@disk_usage}","status":"online"})
      Timecop.return
    end

  end
end
