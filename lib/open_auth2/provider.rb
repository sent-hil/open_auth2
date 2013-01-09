# Contains various providers & their config info stored in
# Options hash. When user sets a provider, we copy over its
# Options to Config. The reason for this setup is b/c various
# OAuth servers accept & return different options & values.
# This way users can contribute their own providers, i.e. a
# very simple plugin system.
#
# Acceptable providers are modules defined under
# OpenAuth2::Provider, have Options hash.
#
# Examples:
#   module OpenAuth2::Providers::YourProviderName
#     Options = {
#       :authorize_url => 'https://your_provider_name.com'
#     }
#   end
module OpenAuth2
  module Provider
  end
end
