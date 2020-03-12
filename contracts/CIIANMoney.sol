//************************************************* */
// Autor Alan Enrique Escudero Caporal
// Fecha 09/Marzo/2020
// Version: 1.0.0
//************************************************* */
pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";

contract CIIANMoney is ERC20, ERC20Detailed {
    //State Variables
    constructor() public ERC20Detailed("CIIANMoney", "CANM", 5) {
        _mint(msg.sender, 10000);
    }
}