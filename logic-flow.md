# Flow for thing of VE to IQ

1. generate token for scaling instance - 
  `export AUTH_TOKEN=$(curl -sk --header "Content-Type: application/json" --request POST --data '{"username":"{biq-user}","password":"{biq-passwd}"}' https://{big-mgmt}/mgmt/shared/authn/login | jq -r '.token.token'`

2. use token to send payload with generated do stanza:
  `curl -sk --header "Content-Type: application/json" --header "X-F5-Auth-Token: '$AUTH_TOKEN'" --request POST --data @do_iq.json https://{biq-mgmt}/mgmt/shared/declarative-onboarding`

3. validation opperation of DO with validation of device list:
  `curl -sk --header "Content-Type: application/json" --header "X-F5-Auth-Token: '$AUTH_TOKEN'" --request POST --data '{
    "devicesQueryUri": "https://localhost/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices?%24filter=product%20eq%20%27BIG-IP%27&%24orderby=hostname%20asc"}' https://{biq-mgmt}/mgmt/cm/device/tasks/device-inventory`

4. Check RegPool:
  `curl -sk --header "Content-Type: application/json" --header "X-F5-Auth-Token: '$AUTH_TOKEN'" --request GET https://{biq-mgmt}/mgmt/cm/device/licensing/pool/regkey/licenses`


