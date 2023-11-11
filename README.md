# Azure Firewall


Get your public IP address and add it to the `home_ips` variable. This will be used for `DNAT`:

```sh
dig +short myip.opendns.com @resolver1.opendns.com
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Threat intelligence will bne executed first. Firewall policy rule types will be processed in the following order:

1. DNAT
2. Network
3. Application
