provider "akamai" {
}

data "akamai_property" "test-wheep-co-uk" {
        name = "buddy.wheep.co.uk"
}

resource "akamai_property_activation" "test-wheep-co-uk-prod" {
        property = data.akamai_property.test-wheep-co-uk.id
        contact = ["icass@akamai.com"]
        network = "PRODUCTION"
        activate = true
}
