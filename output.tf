output "aws_instance_ip" {
  value = "${aws_instance.hadoop.public_ip}"
}
