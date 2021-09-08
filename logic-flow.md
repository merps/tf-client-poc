# Flow for thing of VE to IQ
1. generate token for scaling instance - 
    curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"username":"xyz","password":"xyz"}' \
  http://localhost:3000/api/login

