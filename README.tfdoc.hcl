header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-subnetwork-iam"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-subnetwork-iam.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-subnetwork-iam"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Compute Subnetwork IAM](https://cloud.google.com/compute/docs/access/iam) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1 and is compatible with the Terraform Google Provider version 4._** and 5._**

    This module is part of our Infrastructure as Code (IaC) framework that enables our users and customers to easily deploy and manage reusable, secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources:

      - `google_compute_subnetwork_iam_binding`
      - `google_compute_subnetwork_iam_member`
      - `google_compute_subnetwork_iam_policy`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
        module "terraform-google-subnetwork-iam" {
          source = "github.com/mineiros-io/terraform-google-subnetwork-iam?ref=v0.1.0"

          subnetwork = "my-subnetwork"
          role       = "roles/storage.admin"
          members    = ["user:member@example.com"]
        }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "subnetwork" {
        required    = true
        type        = string
        description = <<-END
            Used to find the parent resource to bind the IAM policy to.
          END
      }

      variable "members" {
        type        = set(string)
        default     = []
        description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`
            - `computed:{identifier}`: An existing key from var.computed_members_map.
          END
      }

      variable "computed_members_map" {
        type        = map(string)
        default     = {}
        description = <<-END
           A map of identifiers to identities to be replaced in 'var.members' or in members of `policy_bindings` to handle terraform computed values.
           The format of each value must satisfy the format as described in `var.members`.
         END
        # readme_example = <<-END
        #   members = [
        #     "user:member@example.com",
        #     "computed:myserviceaccount",
        #   ]
        #   computed_members_map = {
        #     myserviceaccount = "serviceAccount:${google_service_account.service_account.id}"
        #   }
        # END
      }

      variable "role" {
        type        = string
        description = <<-END
            The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
      }

      variable "project" {
        type        = string
        description = <<-END
            The ID of the project in which the resource belongs. If it is not provided, the project will be parsed from the identifier of the parent resource. If no project is provided in the parent identifier and no project is specified, the provider project is used.
          END
      }

      variable "authoritative" {
        type        = bool
        default     = true
        description = <<-END
            Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
          END
      }

      variable "condition" {
        type        = object(condition)
        description = <<-END
          An IAM Condition for the target project IAM binding.
        END

        attribute "expression" {
          required    = true
          type        = string
          description = <<-END
            Textual representation of an expression in Common Expression Language syntax.
          END
        }

        attribute "title" {
          required    = true
          type        = string
          description = <<-END
            A title for the expression, i.e., a short string describing its purpose.
          END
        }

        attribute "description" {
          type        = string
          description = <<-END
            An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
          END
        }
      }

      variable "policy_bindings" {
        type           = list(policy_binding)
        description    = <<-END
            A list of IAM policy bindings.
          END
        readme_example = <<-END
            policy_bindings = [{
              role    = "roles/viewer"
              members = ["user:member@example.com"]
            }]
          END

        attribute "role" {
          required    = true
          type        = string
          description = <<-END
              The role that should be applied.
            END
        }

        attribute "members" {
          type        = set(string)
          default     = var.members
          description = <<-END
              Identities that will be granted the privilege in `role`.
            END
        }

        attribute "condition" {
          type           = object(condition)
          description    = <<-END
              An IAM Condition for a given binding.
            END
          readme_example = <<-END
              condition = {
                expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
                title      = "expires_after_2021_12_31"
              }
            END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
                Textual representation of an expression in Common Expression Language syntax.
              END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
                A title for the expression, i.e. a short string describing its purpose.
              END
          }

          attribute "description" {
            type        = string
            description = <<-END
                An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
              END
          }
        }
      }
    }

    # section {
    #   title = "Extended Resource Configuration"
    #
    #   # please uncomment and add extended resource variables here (resource not the main resource)
    # }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }

    section {
      title   = "Module Outputs"
      content = <<-END
      The following attributes are exported in the outputs of the module:
    END

      output "iam" {
        type        = object(iam)
        description = <<-END
          All attributes of the created 'iam_binding' or 'iam_member' or 'iam_policy' resource according to the mode."
        END
      }
    }

    section {
      title = "External Documentation"

      section {
        title   = "Google Documentation"
        content = <<-END
        - https://cloud.google.com/compute/docs/access/iam
      END
      }

      section {
        title   = "Terraform Google Provider Documentation:"
        content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork_iam
      END
      }
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-subnetwork-iam"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork-iam/blob/main/CONTRIBUTING.md"
  }
}
