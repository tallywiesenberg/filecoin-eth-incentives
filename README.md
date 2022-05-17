# Filecoin Storage Insurance Contract

To prevent IPFS storage downtime, Filecoin enables miners to rent out storage for FIL tokens. However, further incentives beyond FIL exchange can be set up using Ethereum and Tellor. 

This contract is an example of a protocol using Tellor to add token incentives on top of native FIL exchange. In the contract, users can deposit tokens to request coverage for the chance that a Filecoin deal becomes inactive, sending the IPFS pin offline. If the Filecoin deal becomes inactive, users can reclaim their tokens as a claim.
