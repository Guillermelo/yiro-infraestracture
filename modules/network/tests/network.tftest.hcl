mock_provider "aws" {}

variables {
  project_name       = "test"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/20"
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags               = { Owner = "test" }
}

run "regional_network" {
  command = plan

  assert {
    condition     = aws_nat_gateway.this.availability_mode == "regional" && aws_nat_gateway.this.connectivity_type == "public" && aws_nat_gateway.this.subnet_id == null && aws_nat_gateway.this.allocation_id == null && length(aws_nat_gateway.this.availability_zone_address) == 0
    error_message = "RNAT must be public and automatic, without an explicit subnet or EIP."
  }

  assert {
    condition     = aws_subnet.public["0"].cidr_block == "10.0.0.0/24" && aws_subnet.public["1"].cidr_block == "10.0.1.0/24" && aws_subnet.private_app["0"].cidr_block == "10.0.2.0/24" && aws_subnet.private_app["1"].cidr_block == "10.0.3.0/24" && aws_subnet.private_data["0"].cidr_block == "10.0.4.0/24" && aws_subnet.private_data["1"].cidr_block == "10.0.5.0/24"
    error_message = "All six subnets must keep their /24 allocation."
  }

  assert {
    condition     = alltrue([for s in concat(values(aws_subnet.public), values(aws_subnet.private_app), values(aws_subnet.private_data)) : !s.map_public_ip_on_launch]) && aws_vpc.this.tags["Owner"] == "test"
    error_message = "Disable automatic public IP assignment and preserve tags."
  }
}

run "reject_duplicate_azs" {
  command = plan
  variables {
    availability_zones = ["us-east-1a", "us-east-1a"]
  }
  expect_failures = [var.availability_zones]
}

run "reject_wrong_prefix" {
  command = plan
  variables {
    vpc_cidr = "10.0.0.0/16"
  }
  expect_failures = [var.vpc_cidr]
}
