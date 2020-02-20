//************************************************* */
// Autor Alan Enrique Escudero Caporal
// Fecha 19/Febrero/2020
// Version: 1.0.0
//************************************************* */
pragma solidity ^0.5.0;

import '@openzeppelin/contracts/token/ERC721/ERC721Full.sol';
import "@openzeppelin/contracts/drafts/Counters.sol";

contract CIIANToken is ERC721Full {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping (uint256 => Verdura) internal VerduraList;

    struct Verdura{
        uint64 creacionHora;
        string nombreProducto;
    }

    constructor() ERC721Full("CIIAN Token", "CNT") public {
    }

    function createProduct(address _user, string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(_user, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        return newItemId;
    }
}