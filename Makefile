-include .env

deploy:
	forge create Hassan --account hassanAccount --rpc-url ${RPC_URL} --broadcast

verify:
	forge verify-contract \
		${CONTRACT_ADDRESS} \
		src/Hassan.sol:Hassan \
		--chain sepolia \
		--verifier blockscout \
		--verifier-url https://eth-sepolia.blockscout.com/api/ \
		--etherscan-api-key ${BLOCKSCOUT_API_KEY}

verify-etherscan:
	forge verify-contract \
		--chain-id 11155111 \
		--verifier etherscan \
		--etherscan-api-key ${ETHERSCAN_API_KEY} \
		--watch \
		0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB \
		src/Hassan.sol:Hassan