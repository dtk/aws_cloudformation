require_relative('../lib/aws_cloudformation')
module DTKModule
  def self.execute(attributes)
    wrap(attributes, all_types: true) do |all_attributes|
      dynamic_attributes = Aws::CloudFormation::Stack.converge(all_attributes)
      DTK::Response::Ok.new(dynamic_attributes)
    end
  end
end
