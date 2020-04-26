data "template_file" "codebuild_role" {
  template = "${file("templates/greeting.tpl")}"
  vars {
    hello = "goodnight"
    world = "moon"
  }
}
