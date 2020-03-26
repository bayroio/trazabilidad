//************************************************* */
// Autor Alan Enrique Escudero Caporal
// Fecha 19/Febrero/2020
// Version: 1.1.0
//************************************************* */
pragma solidity ^0.5.0;

import '@openzeppelin/contracts/token/ERC721/ERC721Full.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/drafts/Counters.sol";

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC721/ERC721Full.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/IERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/drafts/Counters.sol";

contract CIIANToken is ERC721Full {
    //State Variables
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    IERC20 private _token;
    mapping (uint256 => Producto) TokenList;

    //Structs used
    struct Producto {
        uint64 creacionHora;
        uint16 PLUCode;
        uint16 numAcciones;
        address creacionAddress;
        mapping (uint16 => Accion) Historia;
    }

    struct Accion {
        string descripcionAccion;
        uint64 horaAccion;
        string ubicacionAccion;
        address usuarioAccion;
    }

    //Events
    event VerduraCreada(uint64 _creacionHora, uint16 _PLUCode, address _creacionAddress);
    event AccionTaken(uint16 _PLUCode, string _descripcionAccion, uint64 _horaAccion, address _usuarioAccion);

    constructor() ERC721Full("CIIAN Token", "CIIANT") public {
    }

    function createProduct(uint16 _PLUCode, string memory _ubicacionAccion,
    string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        TokenList[newItemId].creacionHora = uint64(now);
        TokenList[newItemId].PLUCode = _PLUCode;
        TokenList[newItemId].numAcciones = 1;
        TokenList[newItemId].creacionAddress = msg.sender;
        TokenList[newItemId].Historia[1].descripcionAccion = "Creacion del Token";
        TokenList[newItemId].Historia[1].horaAccion = uint64(now);
        TokenList[newItemId].Historia[1].ubicacionAccion = _ubicacionAccion;
        TokenList[newItemId].Historia[1].usuarioAccion = msg.sender;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        emit VerduraCreada(uint64(now), _PLUCode, msg.sender);
        return newItemId;
    }

    function getNumeroAcciones(uint256 _itemID) public view returns (uint16) {
        return (TokenList[_itemID].numAcciones);
    }

    function updateAccionProducto(uint256 _itemID, string memory _descripcionAccion, string memory _ubicacionAccion) public {
        require(_exists(_itemID), "ERR: Token no existe");
        require(ownerOf(_itemID) == msg.sender, "ERR: Esta funcion esta reservada al dueño del token unicamente");
        uint16 _numAcciones = TokenList[_itemID].numAcciones + 1;
        TokenList[_itemID].Historia[_numAcciones].descripcionAccion = _descripcionAccion;
        TokenList[_itemID].Historia[_numAcciones].horaAccion = uint64(now);
        TokenList[_itemID].Historia[_numAcciones].ubicacionAccion = _ubicacionAccion;
        TokenList[_itemID].Historia[_numAcciones].usuarioAccion = msg.sender;
        TokenList[_itemID].numAcciones = _numAcciones;
        emit AccionTaken(TokenList[_itemID].PLUCode, _descripcionAccion, uint64(now), msg.sender);
    }

    function _updateAccionProducto(uint256 _itemID, string memory _descripcionAccion, string memory _ubicacionAccion) private {
        uint16 _numAcciones = TokenList[_itemID].numAcciones + 1;
        TokenList[_itemID].Historia[_numAcciones].descripcionAccion = _descripcionAccion;
        TokenList[_itemID].Historia[_numAcciones].horaAccion = uint64(now);
        TokenList[_itemID].Historia[_numAcciones].ubicacionAccion = _ubicacionAccion;
        TokenList[_itemID].Historia[_numAcciones].usuarioAccion = msg.sender;
        TokenList[_itemID].numAcciones = _numAcciones;
        emit AccionTaken(TokenList[_itemID].PLUCode, _descripcionAccion, uint64(now), msg.sender);
    }

    //Crear un Update privado para que solo sea utilizable por el dueño del Token

    function getEstatusProducto(uint256 _itemID) public view returns (string memory _descripcionAccion, uint64 _horaAccion,
    string memory _ubicacionAccion, address _usuarioAccion) {
        uint16 accionActual = TokenList[_itemID].numAcciones;
        return (TokenList[_itemID].Historia[accionActual].descripcionAccion, TokenList[_itemID].Historia[accionActual].horaAccion,
        TokenList[_itemID].Historia[accionActual].ubicacionAccion, TokenList[_itemID].Historia[accionActual].usuarioAccion);
    }

    function transferFrom(address from, address to, uint256 tokenId, string memory _ubicacionAccion) public {
        super.transferFrom(from, to, tokenId);
        _updateAccionProducto(tokenId, "Cambio de Dueño", _ubicacionAccion);
    }

    //Crear Metodo que envie toda la historia de un Token

}