provider "akamai" {}

variable "env" {
        default = "staging"
}

variable "activate" {
  default = true
}

data "akamai_group" "group" {
  name = "Ian Cass"
}

data "akamai_contract" "contract" {
  group = "${data.akamai_group.group.name}"
}

data "akamai_property" "example" {
    name = "goldenmaster.wheep.co.uk"
    version = 3
}

resource "akamai_cp_code" "test-wheep-co-uk" {
    product  = "prd_Site_Accel"
    contract = "${data.akamai_contract.contract.id}"
    group = "${data.akamai_group.group.id}"
    name        = "test-wheep-co-uk"
}

resource "akamai_edge_hostname" "test-wheep-co-uk" {
    product  = "prd_Site_Accel"
    contract = "${data.akamai_contract.contract.id}"
    group = "${data.akamai_group.group.id}"
    edge_hostname = "tf.wheep.co.uk.edgesuite.net"
}

resource "akamai_property" "test-wheep-co-uk" {
  name        = "buddy.wheep.co.uk"
  cp_code     = "${akamai_cp_code.test-wheep-co-uk.id}"
  contact     = ["icass@akamai.com"]
  contract = "${data.akamai_contract.contract.id}"
  group = "${data.akamai_group.group.id}"
  product     = "prd_Site_Accel"
  rule_format = "v2018-02-27"

  hostnames    = {
        "buddy.wheep.co.uk" = "${akamai_edge_hostname.test-wheep-co-uk.edge_hostname}",
  }

  rules       = data.akamai_property.example.rules
  is_secure = true

}

resource "akamai_property_activation" "test-wheep-co-uk" {
        property = "${akamai_property.test-wheep-co-uk.id}"
        version = "${akamai_property.test-wheep-co-uk.version}"
        contact = ["icass@akamai.com"]
        network = "${upper(var.env)}"
        activate = "${var.activate}"
}
