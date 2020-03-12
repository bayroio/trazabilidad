//************************************************* */
// Autor Alan Enrique Escudero Caporal
// Fecha 19/Febrero/2020
// Version: 1.1.0
//************************************************* */
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/drafts/Counters.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC721/ERC721Full.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/IERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/drafts/Counters.sol";

contract CIIANToken is ERC721Full {
    //State Variables
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    IERC20 private _token;
    mapping (uint256 => Producto) ProductoList;

    //Structs used
    struct Producto {
        uint64 creacionHora;
        uint8 tipoProducto;
        uint16 numAcciones;
        address creacionAddress;
        //mapping (uint16 => uint32) Historia;
        mapping (uint16 => Accion) Historia;
    }
    
    //Esto deberia estar publico?
    struct Accion {
        uint32 idAccion;
        uint64 horaAccion;
        string ubicacionAccion;
        address usuarioAccion;
    }

    //Events
    event VerduraCreada(uint64 _creacionHora, uint8 _tipoProducto);
    event AccionTaken(uint8 _tipoProducto, uint32 _idAccion, uint64 _horaAccion, address _usuarioAccion);

    constructor() ERC721Full("CIIAN Token", "CIIANT") public {
    }
//Quien crea el token sera el mismo que lo posea?
    function createProduct(address _user, uint8 _tipoProducto, string memory _ubicacionAccion,
    string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        //
        ProductoList[newItemId].creacionHora = uint64(now);
        ProductoList[newItemId].tipoProducto = _tipoProducto;
        ProductoList[newItemId].numAcciones = 1;
        ProductoList[newItemId].creacionAddress = msg.sender;
        ProductoList[newItemId].Historia[1].idAccion = 1;
        ProductoList[newItemId].Historia[1].horaAccion = uint64(now);
        ProductoList[newItemId].Historia[1].ubicacionAccion = _ubicacionAccion;
        ProductoList[newItemId].Historia[1].usuarioAccion = msg.sender;
        //
        _mint(_user, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        //emit VerduraCreada(uint64(now), _tipoProducto); //Que cosas deberian ir en el emit
        return newItemId;
    }

    function getNumeroAcciones(uint256 _itemID) public view returns (uint16) {
        return (ProductoList[_itemID].numAcciones);
    }

    function comprarToken(uint8 _tipoProducto, string calldata _ubicacionAccion, string calldata _tokenURI) external{
        address from = msg.sender;
        _token.transferFrom(from, address(this), 1000);
        createProduct(msg.sender, _tipoProducto, _ubicacionAccion, _tokenURI);
    }
}