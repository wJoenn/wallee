Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.execution_mode = :async
  config.good_job.max_threads = 1
  config.good_job.preserve_job_records = false

  config.good_job.cron = {
    keep_alive: {
      cron: "every 10 minutes",
      class: "KeepAliveJob",
      description: "Keeping server alive while unused."
    }
  }
end
