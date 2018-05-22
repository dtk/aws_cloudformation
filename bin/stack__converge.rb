require_relative('../lib/aws_cloudformation')
module DTKModule
  def self.execute(attributes)
    Aws::Stdlib.wrap(attributes, all_types: true) do |all_attributes|
      dynamic_attributes = Aws::Clouformation::Stack.converge(all_attributes)
      DTK::Response::Ok.new(dynamic_attributes)
    end
  end
end
