Pod::HooksManager.register('cocoapods-no-autoimports', :pre_install) do |context, options|
    require 'cocoapods-no-autoimports/plugin'
end