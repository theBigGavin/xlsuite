# Adjusts the cache control to the maximum value of 10 years (315360000 seconds)
module AWS
  module S3
    class S3Object
      class << self
        def store_with_cache_control(key, data, bucket = nil, options = {})
          if (options['Cache-Control'].blank?)
            options['Cache-Control'] = 'max-age=315360000'
          end
          store_without_cache_control(key, data, bucket, options)
        end

        alias_method_chain :store, :cache_control
      end
    end
  end
end

require 'technoweenie/attachment_fu/backends/s3_backend'
  module Technoweenie
    module AttachmentFu
      module Backends
        module S3Backend
        def authenticated_s3_url(*args)
          options = args.extract_options!
          options[:expires] = Time.now.advance(:minutes => 5).end_of_day.to_i if options[:expires].blank? and options[:expires_on].blank?
          thumbnail = args.shift
          S3Object.url_for(full_filename(thumbnail), bucket_name, options)
        end
      end
    end
  end
end
