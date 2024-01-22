**Jumpcoin**

https://github.com/validierungcc/jumpcoin-docker

https://jumpcoin.net/


minimal example docker-compose.yml

     ---
    version: '3.9'
    services:
        jumpcoin:
            container_name: jumpcoin
            image: vfvalidierung/jumpcoin:latest
            restart: unless-stopped
            ports:
                - '31242:31242'
                - '127.0.0.1:31240:31240'
            volumes:
                - 'jumpcoin_data:/jump/.jumpcoin'
    volumes:
       jumpcoin_data:

**RPC Access**

    curl --user 'jumpcoinrpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:31240
