provider "aws" {

  region = "us-east-1"

  access_key = "ASIAQTQPQEXZUG4GCTFA"

  secret_key = "X4SXObI/7HM53W5aSqlAHzzSTZK/2Vnb4p5Uclx4"

  token = "FwoGZXIvYXdzEMj//////////wEaDJSsknfmjmcLKpaKiCKCAULG4Wvpm9cNM2A+rpfoLVrs4LQCnm0jEtoPFfCx1TzV71X8eFMo7MJw1lUvO9F0FgHSAD/i5OMcHB8UItswWXdM3dEJSZuhfhNlPP2hcfaxZU9vfdVnitxSKXmqXXi/9CPDY6xCglUDYO6XqW+kdSw22VWlwp/tsiAj+rFX7H0iWgco9YrUoQYyKBNt6g+rV+XY8mO+9K4mwgNCRTJzm1sZgz2fucJBygSX/N3PIScX0VE="
}




resource "aws_launch_configuration" "Clim-DM" {
  image_id = "ami-05adf8b06ab95608e"

  instance_type = "t3.micro"
  security_groups = [aws_security_group.Clim-DM.id]

  user_data = data.template_file.user_data.rendered

}




resource "aws_security_group" "Clim-DM" {

  name_prefix = "Clim-DM"

}




resource "aws_autoscaling_group" "Clim-DM" {

  desired_capacity = 1

  launch_configuration = aws_launch_configuration.Clim-DM.id

  max_size = 5

  min_size = 1

  name = "Clim-DM-asg"

  target_group_arns = [aws_lb_target_group.Clim-DM.arn]

  vpc_zone_identifier = aws_subnet.public.*.id

}




data "template_file" "user_data" {

  template = file("userdata.sh")

}




resource "aws_lb" "Clim-DM" {

  internal = false

  load_balancer_type = "application"

  name = "Clim-DM-lb"

  security_groups = [aws_security_group.Clim-DM.id]

  subnets = aws_subnet.public.*.id

}




resource "aws_lb_target_group" "Clim-DM" {

  name = "Clim-DM-target-group"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.default.id

}




resource "aws_lb_listener" "Clim-DM" {

  load_balancer_arn = aws_lb.Clim-DM.arn

  port = "80"

  protocol = "HTTP"

  default_action {

    target_group_arn = aws_lb_target_group.Clim-DM.arn

    type = "forward"

  }

}




resource "aws_vpc" "default" {

  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true

}




resource "aws_subnet" "public" {

  cidr_block = "10.0.4.0/24"

  map_public_ip_on_launch = true

  vpc_id = aws_vpc.default.id

  availability_zone = "us-east-1a"

}




resource "aws_subnet" "public2" {

  cidr_block = "10.0.5.0/24"

  map_public_ip_on_launch = true

  vpc_id = aws_vpc.default.id

  availability_zone = "us-east-1b"

}