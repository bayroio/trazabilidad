// Load dependencies
const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

// Import utilities from Test Helpers
const {expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const CIIANToken = contract.fromArtifact('CIIANToken');

// Start test block
describe('CIIANToken', function () {
  const [ owner, owner2, other, other2] = accounts;

  before(async function () {
    this.contract = await CIIANToken.new({ from: owner });
  });

  // Test: Creacion de un Token
  it('Crear un nuevo Token', async function () {
    const receipt = await this.contract.createProduct(1234, "@19.4687249,-99.1345574,15z", "XWZ", { from: owner });
    expectEvent(receipt, 'VerduraCreada', { _PLUCode: "1234", _creacionAddress: owner});
  });
  // Test: Se intenta actualizar un Token que no existe
  it('Se intenta actualizar un Token que no existe', async function () {
    await expectRevert(this.contract.updateAccionProducto(666, "Se realiza la Plantacion", "@19.4572891,-99.1409066,15z", { from: owner }),'ERR: Token no existe');
  });
  // Test: Se intenta actualizar con una cuenta que no es el dueño del Token
  it('Se intenta actualizar con una cuenta que no es el dueño del Token', async function () {
    await expectRevert(this.contract.updateAccionProducto(1, "Se realiza la Plantacion", "@19.4572891,-99.1409066,15z", { from: other }),'ERR: Esta funcion esta reservada al dueño del token unicamente');

  });
  // Test: Se actualiza la accion de un Producto para marcar la Plantacion
  it('Se actualiza la accion de un Producto para marcar la Plantacion', async function () {
    await this.contract.updateAccionProducto(1, "Se realiza la Plantacion", "@19.4572891,-99.1409066,15z", { from: owner });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('Se realiza la Plantacion');
  });
  // Test: Se actualiza la accion de un Producto para marcar el Cultivo y se cacha el evento de actualizacion
  it('Se actualiza la accion de un Producto para marcar el Cultivo y se cacha el evento de actualizacion', async function () {
    const receipt = await this.contract.updateAccionProducto(1, "Se realiza el Cultivo", "@19.4572891,-99.1409066,15z", { from: owner });
    expectEvent(receipt, 'AccionTaken', { _PLUCode: "1234", _descripcionAccion: "Se realiza el Cultivo", _usuarioAccion: owner});
  });
  // Test: Se pasa el Ownership del Token al encargado de Transportacion
  it('Se pasa el Ownership del Token al encargado de Transportacion', async function () {
    await this.contract.transferFrom(owner, other, 1, "@19.4454326,-99.1450265,15z", { from: owner });
    expect((await this.contract.ownerOf(1))).to.equal(other);
  });
  // Test: Se actualiza la accion de un Producto para marcar el transporte a una Bodega de concentraciona
  it('Se actualiza la accion de un Producto para marcar el transporte a una Bodega de concentracion', async function () {
    await this.contract.updateAccionProducto(1, "En Camino a la Bodega de Concentracion", "@19.4454326,-99.1450265,15z", { from: other });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('En Camino a la Bodega de Concentracion');
  });
  // Test: Se actualiza la accion de un Producto para marcar el transporte hacia un Retail
  it('Se actualiza la accion de un Producto para marcar el transporte hacia un Retail', async function () {
    await this.contract.updateAccionProducto(1, "En camino Wallmart", "@19.4259666,-99.13919,15z", { from: other });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('En camino Wallmart');
  });
  // Test: Se actualiza la accion de un Producto para indicar que fue entregado al Retail final
  it('Se actualiza la accion de un Producto para indicar que fue entregado al Retail final', async function () {
    await this.contract.updateAccionProducto(1, "Entregada al Wallmart Universidad", "@19.3666684,-99.1657755,16z", { from: other });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('Entregada al Wallmart Universidad');
  });
  // Test: Se pasa el Ownership del Token al gerente de Wallmart
  it('Se pasa el Ownership del Token al gerente de Wallmart', async function () {
    await this.contract.transferFrom(other, other2, 1, "@19.4454326,-99.1450265,15z", { from: other });
    expect((await this.contract.ownerOf(1))).to.equal(other2);
  });
  // Test: Validacion del numero de acciones
  it('Validacion del numero de acciones', async function () {
    expect((await this.contract.getNumeroAcciones(1)).toString()).to.equal('8');
  });
  // Test: Obtencion de la Historia del Producto
  // Test: Se crea un nuevo token de un tipo diferente
  it('Se crea un nuevo token de un tipo diferente', async function () {
    const receipt = await this.contract.createProduct(55331, "@19.4687249,-99.1345574,15z", "ABC", { from: owner2 });
    expectEvent(receipt, 'VerduraCreada', { _PLUCode: "55331", _creacionAddress: owner2});
  });
  // Test: Validar numero total de Tokens
  it('Validar numero total de Tokens', async function () {
    expect((await this.contract.totalSupply()).toString()).to.equal('2');
  });
  // Test: Validar que el dueño del Token 2 sea owner2
  it('Validar que el dueño del Token 2 sea owner2', async function () {
    expect((await this.contract.ownerOf(2))).to.equal(owner2);
  });
  // Agregar un Metodo que traiga toda la historia
});