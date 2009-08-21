class TimerWorker < BackgrounDRb::MetaWorker
  set_worker_name :timer_worker
  def create(args = nil)
    #logger.debug("heelo #{args.inspect}")
    #logger.debug("heelo #{client.session_id}")
    #@client = client
    #add_periodic_timer(60) { check_client }
    #check_client
    #check_client
  end

  def check_client
    #logger.debug("heelo #{@client.session_id}")
    logger.debug('heelo')
    #logger.debug("session id: #{session_id}")
  end
end

