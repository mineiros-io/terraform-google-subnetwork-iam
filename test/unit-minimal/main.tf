module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  subnetwork = "unit-minimal-${local.random_suffix}"
}
