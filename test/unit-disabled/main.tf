module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  subnetwork = "unit-disabled-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources
}
