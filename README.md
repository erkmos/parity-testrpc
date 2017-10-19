### Dockerised Parity 

Intended use is for running solidity unit tests, with e.g. Truffle. It starts a 
parity instance with 10 unlocked accounts on port 8945, in geth compatibility mode.

```
docker build -t paritytestrpc .
docker run -ti -p 8945:127.0.0.1:8945 paritytestrpc
```