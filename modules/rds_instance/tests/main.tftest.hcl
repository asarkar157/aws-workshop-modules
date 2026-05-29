mock_provider "aws" {}

variables {
  identifier = "test-rds-instance"
  password   = "test-Password-123!"
  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
}

run "plan" {
  command = plan

  assert {
    condition     = aws_db_instance.this.identifier == "test-rds-instance"
    error_message = "primary instance identifier must match the input"
  }

  assert {
    condition     = aws_db_instance.this.multi_az == false
    error_message = "multi_az must default to false to preserve backward compatibility"
  }

  assert {
    condition     = aws_db_instance.this.backup_retention_period == 7
    error_message = "backup_retention_period must default to 7"
  }

  assert {
    condition     = length(aws_db_instance.replica) == 0
    error_message = "no read replicas should be created by default"
  }

  assert {
    condition     = output.db_instance_name == "workshopdb"
    error_message = "db_instance_name output must surface the configured db_name"
  }

  assert {
    condition     = length(output.read_replica_ids) == 0
    error_message = "read_replica_ids must be empty by default"
  }

  assert {
    condition     = length(output.read_replica_endpoints) == 0
    error_message = "read_replica_endpoints must be empty by default"
  }
}

run "global_ha" {
  command = plan

  variables {
    multi_az           = true
    read_replica_count = 2
  }

  assert {
    condition     = aws_db_instance.this.multi_az == true
    error_message = "primary instance must enable multi_az when requested"
  }

  assert {
    condition     = length(aws_db_instance.replica) == 2
    error_message = "two read replicas must be created when read_replica_count = 2"
  }

  assert {
    condition     = alltrue([for r in aws_db_instance.replica : r.multi_az == true])
    error_message = "read replicas must inherit the multi_az setting"
  }

  assert {
    condition     = alltrue([for r in aws_db_instance.replica : r.replicate_source_db == aws_db_instance.this.identifier])
    error_message = "read replicas must replicate from the primary instance"
  }

  assert {
    condition     = length(output.read_replica_ids) == 2
    error_message = "read_replica_ids must list both replicas"
  }

  assert {
    condition     = length(output.read_replica_endpoints) == 2
    error_message = "read_replica_endpoints must list both replica endpoints"
  }
}
