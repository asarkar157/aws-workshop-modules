resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.identifier}-subnet-group" })
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for RDS instance ${var.identifier}"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Assuming internal VPC access
  }

  tags = merge(var.tags, { Name = "${var.identifier}-sg" })
}

resource "aws_db_instance" "this" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = merge(var.tags, { Name = var.identifier })
}

# Read replicas provide additional high-availability and read-scaling
# endpoints. They are created only when var.read_replica_count > 0 so the
# default behaviour (a single primary instance) is unchanged.
resource "aws_db_instance" "replica" {
  count = var.read_replica_count

  identifier             = "${var.identifier}-replica-${count.index + 1}"
  replicate_source_db    = aws_db_instance.this.identifier
  instance_class         = var.instance_class
  vpc_security_group_ids = [aws_security_group.this.id]
  multi_az               = var.multi_az
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = merge(var.tags, { Name = "${var.identifier}-replica-${count.index + 1}" })
}
