
# Study of Dynamic Contents in Blockchain-based NFTs (PARK JIHWAN / 2023)

## Abstract
Blockchain-based NFTs are used in various fields including art fields such as art, music and virtual fields such as games, metaverses and physical worlds such as IoT, real estate, sports. However, since the current ERC-721-based NFTs have several limitations, the application of dynamic content to NFTs is required to overcome the limitations and popularize NFTs.
In order to apply the dynamic content of NFT, the Metadata distributed on the Blockchain should be modified. Depending on the Metadata and storage location of Media Data, it can be classified into Server-Client, Peer to Peer, and On Chain methods. Server-Client is a method to modify the response Metadata of the RESTful URI delivered during the initial minting. Peer to Peer and On Chain are methods of modifying the Metadata of NFTs through new transactions by transferring the IPFS address and Base64-encoded Data URL Scheme of TokenURI to Metadata, respectively.
As a result of experimentation and analysis of each method based on transaction fee and security, Server- Client did not incur any additional transaction fee, and low availability and integrity were guaranteed due to its composition as a centralized server. Peer to Peer was found to guarantee higher availability and integrity than Server-Client, without consuming higher transaction fees compared to the On-Chain method. On Chain has high availability and integrity, but was found to consume a lot of transaction fees due to the large size of data transmitted when a transaction occurs.

## Tech Stack Overview
- API: PHP Laravel 9
- App: Swift IOS
- BlockChain Network: Ethereum TestNet (Sepolia)
- Cryptocurrency wallet: MetaMask
- Programming Language: Solidity 0.8.0
- IDE: Remix Online / Desktop
- Media Storage: Naver Cloud Object Storage


## Paper
- https://drive.google.com/file/d/1yGYT43C651os-FLOqh3_oVlxTfzalCaa/view?usp=sharing