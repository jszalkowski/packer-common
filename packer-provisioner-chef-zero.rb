Racker::Processor.register_template do |t|
  t.provisioners = {
    5 => {
      "create-packer-folders" => {
        "type" => "shell",
        "inline" => [
          "set -e",
          "curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -v 12.2.1",
          "install -d -m 755 -o ubuntu /tmp/packer-chef-client",
          "sudo install -d -m 777 -o root -g root /etc/chef"
          # "sudo mkdir -p /etc/chef",
          # "sudo chmod 777 /etc/chef",
          # "sudo chown -R root:root /etc/chef",
          # "sudo mkdir -p /tmp/packer-chef-client",
          # "sudo chown -R root:root /tmp/packer-chef-client",
          # "sudo chmod 777 /tmp/packer-chef-client"
        ]
      }
    },
    6 => {
      "create-cookbooks" => {
        "type" => "file",
        "source"=> "{{pwd}}/berks-cookbooks",
        "destination"=> "/etc/chef/cookbooks"
      }
    },
    7 => {
      "create-databags" => {
        "type"=> "file",
        "source"=> "{{pwd}}/databags_checkout",
        "destination"=> "/etc/chef/data_bags"
      }
    },
    8 => {
      "copy-chef-pem" => {
        "type" => "file",
        "source"=> "{{pwd}}/packer_common_checkout/chef.pem",
        "destination"=> "/etc/chef/chef.pem"
      }
    },
    9 => {
      "copy-knife-rb" => {
        "type" => "file",
        "source"=> "{{pwd}}/packer_common_checkout/knife.rb",
        "destination"=> "/etc/chef/knife.rb"
      }
    },
    # 10 => {
    #   "chef" => {
    #     "execute_command"=> "cd /etc/chef && \
    #     sudo chef-client --no-color --local-mode \
    #     -c /tmp/packer-chef-client/client.rb \
    #     -j /tmp/packer-chef-client/first-boot.json \
    #     -l {{user `chef_log_level`}} && \
    #     sudo knife node delete localhost -c /etc/chef/knife.rb -z -k /etc/chef/chef.pem -y && \
    #     sudo knife client delete localhost -c /etc/chef/knife.rb -z -k /etc/chef/chef.pem -y",
    #     "server_url" => "http://localhost:8889",
    #     "install_command"=> "sudo bash -c 'curl -L https://www.opscode.com/chef/install.sh| bash -s -- -v 12.2.1'",
    #     "prevent_sudo"=> false,
    #     "skip_install"=> false,
    #     "type"=> "chef-client",
    #     "config_template" => "{{pwd}}/packer_common_checkout/chef-zero-client.rb"
    #   }
    # },
    10 => {
      "run-chef-zero" => {
        "type" => "shell",
        "inline"=> [
          "cd /etc/chef",
          "sudo chef-client --no-color --local-mode \
          -c /tmp/packer-chef-client/client.rb \
          -j /tmp/packer-chef-client/first-boot.json \
          -l :info",
          "sudo knife node delete localhost -c /etc/chef/knife.rb -z -k /etc/chef/chef.pem -y",
          "sudo knife client delete localhost -c /etc/chef/knife.rb -z -k /etc/chef/chef.pem -y"
        ]
        # "server_url" => "http://localhost:8889",
        # "install_command"=> "sudo bash -c 'curl -L https://www.opscode.com/chef/install.sh| bash -s -- -v 12.2.1'",
        # "prevent_sudo"=> false,
        # "skip_install"=> false,
        # "type"=> "chef-client",
        # "config_template" => "{{pwd}}/packer_common_checkout/chef-zero-client.rb"
      }
    },
    100 => {
      "cleanup-network" => {
        "type"=> "shell",
        "inline" => [
          "sudo sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0",
          "sudo sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0",
          "sudo rm -Rf /etc/udev/rules.d/70-persistent-net.rules"
        ]
      }
    }
  }
end
