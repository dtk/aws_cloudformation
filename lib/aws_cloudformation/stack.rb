module DTKModule
  module Aws::CloudFormation
    class Stack
      require 'aws-sdk'

      attr_reader :attributes

      def self.converge(all_attributes)
        @region = attributes_hash[:region] || 'us-east-1'
        attributes_hash = all_attributes.av_hash rescue all_attributes
        @stack_name = attributes_hash[:stack_name]
        parameters_hash = attributes_hash[:parameters]
        template_url = attributes_hash[:template_url]
        capabilites = attributes_hash[:capabilities]

        @cloudformation ||= Aws::CloudFormation::Client.new(region: @region)

        raise '@stack_name missing' unless @stack_name

        # generate parameters
        # example:
        # parameters = [{ parameter_key: 'InstanceName', parameter_value: @instance_name }]
        parameters = []
        parameters_hash.each do |k,v|
          parameters << { parameter_key: k.to_s, parameter_value: v }
        end
        
        on_failure = 'DO_NOTHING'
        resp_create = @cloudformation.create_stack \
          stack_name: @stack_name, template_url: template_url,
          parameters: parameters, on_failure: on_failure
        resp = create_stack_waiter
        # format dynamic attributes
        {:output => resp}
      end

      def self.delete(all_attributes)
        @region = attributes_hash[:region] || 'us-east-1'
        attributes_hash = all_attributes.av_hash rescue all_attributes
        @stack_name = attributes_hash[:stack_name]
        @cloudformation ||= Aws::CloudFormation::Client.new(region: @region)
        # delete stack and wait for the operation to finish
        delete_stack
        delete_stack_waiter
      end

      def self.create_stack_waiter
        resp = @cloudformation.wait_until :stack_create_complete, stack_name: @stack_name
        # outputs
        # resp[:stacks][0][:outputs]
        resp
      end
      
      def self.delete_stack
        resp = @cloudformation.delete_stack stack_name: @stack_name
      end
      
      def self.delete_stack_waiter
        resp = @cloudformation.wait_until :stack_delete_complete, stack_name: @stack_name
      end
      
      # def cleanup
      #   puts 'Deleting stack...';       ap resp = delete_stack
      #   puts 'Waiting for deletion...'; ap resp = delete_stack_waiter
      #   true
      # end
      # # opts can have keys:
      # #   :system_attributes
      # def initialize(credentials_handle, name, attributes, opts = {})
      #   credentials_handle_obj = CredentialsHandle.create(credentials_handle)
      #   @name               = name
      #   @attributes         = attributes
      #   @system_attributes  = opts[:system_attributes]
      #   @region             = credentials_handle_obj.region
      #   @client             = credentials_handle_obj.client(aws_client_class)
      # end

      # def self.create(object)
      #   if object.kind_of?(DTK::Attributes::AllTypes)
      #     all_attributes = object
      #     attributes     = all_attributes.component

      #     new(attributes.aws_credentials_handle, attributes.value(:name), attributes, system_attributes: all_attributes.system)
      #   else
      #     fail "Unexpected argument type '#{object.class}'"
      #   end
      # end

      # protected

      # attr_reader :region

      # private

      # def aws_api_operation(operation_type)
      #   aws_api_operation_class(operation_type).new(self)
      # end
      
      # def aws_api_operation_class(operation_type)
      #   self.class::Operation.aws_api_operation_class(operation_type)
      # end

      # def aws_client_class
      #   fail "This method should be overwritten by concrete class"
      # end

    end
  end
end


