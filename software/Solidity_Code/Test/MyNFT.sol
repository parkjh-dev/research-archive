// SPDX-License-Identifier: MIT // 이 컨트랙트의 코드는 MIT 라이선스를 따름
pragma solidity ^0.8.0; // 솔라디티 버전 0.8.0 이상을 사용하겠다는 선언

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // ERC721.sol 파일에서 ERC721 컨트랙트를 가져옵니다.
import "@openzeppelin/contracts/utils/Counters.sol"; // Counters.sol 파일에서 Counters 라이브러리를 가져옵니다.
import "@openzeppelin/contracts/access/Ownable.sol"; // Ownable.sol 파일에서 Ownable 컨트랙트를 가져옵니다.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // ERC721URIStorage.sol 파일에서 ERC721URIStorage 컨트랙트를 가져옵니다.

// ERC721URIStorage와 Ownable 컨트랙트를 상속하는 MyNFT 컨트랙트를 정의. contract는 객체지향 언어에서 class와 같은 개념. 한 파일 내 2개 이상 가질 수 있음.
contract dNFT is ERC721URIStorage, Ownable {
    // Counters 라이브러리를 사용하여 토큰 ID를 관리합니다.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // MyNFT 생성자입니다. ERC721의 name과 symbol을 설정합니다.
    constructor() ERC721("MydNFT", "dNFT") {}

    // 특정 토큰 ID에 대한 토큰 URI를 설정합니다. 이 함수는 오직 토큰의 소유자 또는 승인된 사용자만이 호출할 수 있습니다.
    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _setTokenURI(tokenId, tokenURI);
    }

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment(); // 토큰 ID를 증가시킵니다.

        uint256 newItemId = _tokenIds.current(); // 현재 토큰 ID를 가져옵니다.
        _mint(recipient, newItemId); // 지정된 수신자에게 NFT를 할당합니다.
        _setTokenURI(newItemId, tokenURI); // 새로운 토큰의 URI를 설정합니다.

        return newItemId; // 현재 토큰 ID를 반환함.
    }

    // 외부 데이터 가져오는 코드 포함 예정


    // 스마트 컨트랙트 배포 할 때 이미지 주소를 모두 포함할 것인지 아님 매번 변경 될 때 받을 것인지 결정해야 할 듯.

}
