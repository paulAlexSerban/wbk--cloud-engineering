
# Generate a self-signed certificate for localhost
openssl req -x509 -out certs/openssl/localhost.crt -keyout certs/openssl/localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=paulserban.eu' -extensions EXT -config <( \
   printf "[dn]\nCN=paulserban.eu\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:paulserban.eu\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")