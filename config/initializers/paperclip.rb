Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
if Rails.env == 'production'
  Paperclip::Attachment.default_options[:path] = ':production/:id/:style/:filename'
else
  Paperclip::Attachment.default_options[:path] = ':staging/:id/:style/:filename'
end
