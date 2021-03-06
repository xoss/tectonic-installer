module "ca_certs" {
  source = "../../modules/tls/ca/self-signed"

  root_ca_cert_pem = "${var.tectonic_ca_cert}"
  root_ca_key_alg  = "${var.tectonic_ca_key_alg}"
  root_ca_key_pem  = "${var.tectonic_ca_key}"
}

module "kube_certs" {
  source = "../../modules/tls/kube"

  kube_ca_cert_pem       = "${module.ca_certs.kube_ca_cert_pem}"
  kube_ca_key_alg        = "${module.ca_certs.kube_ca_key_alg}"
  kube_ca_key_pem        = "${module.ca_certs.kube_ca_key_pem}"
  aggregator_ca_cert_pem = "${module.ca_certs.aggregator_ca_cert_pem}"
  aggregator_ca_key_alg  = "${module.ca_certs.aggregator_ca_key_alg}"
  aggregator_ca_key_pem  = "${module.ca_certs.aggregator_ca_key_pem}"
  kube_apiserver_url     = "https://${module.dns.api_internal_fqdn}:443"
  service_cidr           = "${var.tectonic_service_cidr}"
}

module "etcd_certs" {
  source = "../../modules/tls/etcd"

  etcd_ca_cert_pem    = "${module.ca_certs.etcd_ca_cert_pem}"
  etcd_ca_key_alg     = "${module.ca_certs.etcd_ca_key_alg}"
  etcd_ca_key_pem     = "${module.ca_certs.etcd_ca_key_pem}"
  service_cidr        = "${var.tectonic_service_cidr}"
  etcd_cert_dns_names = "${data.template_file.etcd_hostname_list.*.rendered}"
}

module "ingress_certs" {
  source = "../../modules/tls/ingress/self-signed"

  base_address = "${module.dns.ingress_internal_fqdn}"
  ca_cert_pem  = "${module.ca_certs.kube_ca_cert_pem}"
  ca_key_alg   = "${module.ca_certs.kube_ca_key_alg}"
  ca_key_pem   = "${module.ca_certs.kube_ca_key_pem}"
}

module "identity_certs" {
  source = "../../modules/tls/identity"

  kube_ca_cert_pem = "${module.ca_certs.kube_ca_cert_pem}"
  kube_ca_key_alg  = "${module.ca_certs.kube_ca_key_alg}"
  kube_ca_key_pem  = "${module.ca_certs.kube_ca_key_pem}"
}
