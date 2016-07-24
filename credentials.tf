provider "aws" {
  profile = "${var.aws_credentials_profile}"
  region  = "${var.region}"
}
