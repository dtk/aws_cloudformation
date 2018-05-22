require 'aws-sdk'

# TODO: replace with a 'dtk_module_require' method supplied by ruby provider
require_relative('../../dtk_stdlib/lib/dtk_stdlib')
module DTKModule
  module Aws
    module CloudFormation
      require_relative('aws_cloudformation/stack')
      
    end
  end
end
