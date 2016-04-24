available_azs = %w( us-east-1a us-east-1b us-east-1c )

SparkleFormation.new('demoapp') do
  description 'Demo application deployment'

  parameters.instance_type do
    allowed_values %w(m3.medium)
    constraint_description 'Must be a valid, EC2 classic compatible instance type.'
    default 'm3.medium'
    description 'EC2 instance type'
    type 'String'
  end

  resources do
    demoapp_elb do
      type 'AWS::ElasticLoadBalancing::LoadBalancer'
      properties do
        availability_zones available_azs 
        listeners [ { 'LoadBalancerPort' => 80,
                      'InstancePort' => 80,
                      'Protocol' => 'HTTP' 
                  } ]

        health_check({ 'Target' => 'TCP:80', 'Interval' => 30, 'UnhealthyThreshold' => 2,
                       'HealthyThreshold' => 2, 'Timeout' => 10 })
      end
    end

    demoapp_iam do
      type 'AWS::IAM::Role'
      properties do
        path '/'
        policies([ { 'PolicyName' => 'root',
                     'PolicyDocument' => {
                       'Version' => '2012-10-17',
                       'Statement' => [ {
                          'Effect' => 'Allow',
                          'Action' => '*',
                          'Resource' => '*'
                       } ]
                     }
                  }])
        assume_role_policy_document({ 'Version' => '2012-10-17', 
                                      'Statement' => [ { 'Effect' => 'Allow', 
                                                         'Principal' => { 
                                        'Service' => ['ec2.amazonaws.com']
                                      }, 
                                      'Action' => ['sts:AssumeRole'] 
                                    }
                                    ]})
      end
    end

    demoapp_iam_profile do
      type 'AWS::IAM::InstanceProfile'
      properties do
        path '/'
        roles [ref!(:demoapp_iam)]
      end
    end

    demoapp_sg do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description 'Demo application security group'
        security_group_ingress [
          { 
            'FromPort' => 80, 
            'ToPort' => 80, 
            'IpProtocol' => 'tcp',
            'SourceSecurityGroupOwnerId' => 'amazon-elb', 
            'SourceSecurityGroupName' => 'amazon-elb-sg'
          },
          { 
            'FromPort' => 22, 
            'ToPort' => 22, 
            'IpProtocol' => 'tcp',
            'CidrIp' => '0.0.0.0/0'
          }
        ]
        tags [
          { 'Key' => 'Name', 'Value' => 'demoapp' }
        ]
      end
    end

    demoapp_stack_sg_self_ingress_tcp do
      type 'AWS::EC2::SecurityGroupIngress'
      properties do
        group_name ref!(:demoapp_sg)
        source_security_group_name ref!(:demoapp_sg)
        ip_protocol 'tcp'
        from_port '80'
        to_port '80'
      end
    end

    bootstrap_template = File.dirname(__FILE__) + "/../chef/chef-zero-1404-bootstrap.sh"  

    demoapp_lc do
      type 'AWS::AutoScaling::LaunchConfiguration'
      properties do
        image_id 'ami-9c5046f6' # Ubuntu 14.04 instance-store ami
        security_groups [ ref!(:demoapp_sg) ]
        iam_instance_profile ref!(:demoapp_iam_profile)
        instance_type ref!(:instance_type)
        key_name 'demoapp' 
        user_data base64!(File.read(bootstrap_template))
      end
    end

    demoapp_asg do
      type 'AWS::AutoScaling::AutoScalingGroup'
      properties do
        availability_zones available_azs 
        launch_configuration_name ref!(:demoapp_lc)
        load_balancer_names [ ref!(:demoapp_elb) ]
        min_size 2
        max_size 5
        tags [ { 'Key' => 'Name', 'Value' => 'demoapp', 'PropagateAtLaunch' => 'true' }]
      end
    end
  end
end
