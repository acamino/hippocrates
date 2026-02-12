# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self
  policy.font_src    :self, 'cdnjs.cloudflare.com'
  policy.img_src     :self, :data
  policy.object_src  :none
  policy.script_src  :self, :unsafe_inline, 'cdnjs.cloudflare.com', 'maxcdn.bootstrapcdn.com'
  policy.style_src   :self, :unsafe_inline, 'cdnjs.cloudflare.com', 'maxcdn.bootstrapcdn.com'
  policy.connect_src :self
end

# Start in report-only mode to detect violations without blocking resources.
# Monitor logs/reports, then switch to enforcing once no violations are seen.
Rails.application.config.content_security_policy_report_only = true
