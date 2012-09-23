Sunspot.session = Sunspot::Sinatra.build_session
Sunspot::Adapters::InstanceAdapter.register(Sunspot::Sinatra::Adapters::ActiveRecordInstanceAdapter, ActiveRecord::Base)
Sunspot::Adapters::DataAccessor.register(Sunspot::Sinatra::Adapters::ActiveRecordDataAccessor, ActiveRecord::Base)
ActiveRecord::Base.module_eval { include(Sunspot::Sinatra::Searchable) }
