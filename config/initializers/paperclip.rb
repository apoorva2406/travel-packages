Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
if Rails.env == 'production'
  Paperclip::Attachment.default_options[:path] = ':photo/:id/:style/:filename'
else
  Paperclip::Attachment.default_options[:path] = ':photo/:id/:style/:filename'
end
