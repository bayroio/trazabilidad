//************************************************* */
// Autor Alan Enrique Escudero Caporal
// Fecha 19/Febrero/2020
// Version: 1.0.0
//************************************************* */
pragma solidity ^0.5.0;

import '@openzeppelin/contracts/token/ERC721/ERC721Full.sol';
import "@openzeppelin/contracts/drafts/Counters.sol";

contract CIIANToken is ERC721Full {
    //State Variables
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping (uint256 => Verdura) VerduraList;

    //Structs used
    struct Verdura{
        uint64 creacionHora;
        uint8 tipoProducto;
        uint16 numAccion;
        mapping (uint16 => uint32) Historia;
//      mapping (uint16 => Accion) internal Historia;
    }

    struct Accion{
        uint32 idAccion;
        uint64 horaAccion;
        string ubicacionAccion;
        address usuarioAccion;
    }

    //Events
    event VerduraCreada(uint64 _creacionHora, uint8 _tipoProducto);
    event AccionTaken(uint8 _tipoProducto, uint32 _idAccion, uint64 _horaAccion, address _usuarioAccion);

    constructor() ERC721Full("CIIAN Token", "CNT") public {
    }

    function createProduct(address _user, string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_user, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        //emit VerduraCreada(_creacionHora, _tipoProducto);
        return newItemId;
    }

    function getNumeroAcciones(uint256 _itemID) public returns (uint16){
        return (VerduraList[_itemID].numAccion);
    }
}