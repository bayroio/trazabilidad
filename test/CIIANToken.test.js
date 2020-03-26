// Load dependencies
const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

// Import utilities from Test Helpers
const {expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const CIIANToken = contract.fromArtifact('CIIANToken');

// Start test block
describe('CIIANToken', function () {
  const [ owner, other ] = accounts;

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
  // Test: Se actualiza la accion de un Producto para marcar el transporte a una Bodega de concentracion
  it('Se actualiza la accion de un Producto para marcar el transporte a una Bodega de concentracion', async function () {
    await this.contract.updateAccionProducto(1, "En Camino a la Bodega de Concentracion", "@19.4454326,-99.1450265,15z", { from: owner });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('En Camino a la Bodega de Concentracion');
  });
  // Test: Se actualiza la accion de un Producto para marcar el transporte hacia un Retail
  it('Se actualiza la accion de un Producto para marcar el transporte hacia un Retail', async function () {
    await this.contract.updateAccionProducto(1, "En camino Wallmart", "@19.4259666,-99.13919,15z", { from: owner });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('En camino Wallmart');
  });
  // Test: Se actualiza la accion de un Producto para indicar que fue entregado al Retail final
  it('Se actualiza la accion de un Producto para indicar que fue entregado al Retail final', async function () {
    await this.contract.updateAccionProducto(1, "Entregada al Wallmart Universidad", "@19.3666684,-99.1657755,16z", { from: owner });
    expect((await this.contract.getEstatusProducto(1))._descripcionAccion.toString()).to.equal('Entregada al Wallmart Universidad');
  });
  // Test: Validacion del numero de acciones
  it('Validacion del numero de acciones', async function () {
    expect((await this.contract.getNumeroAcciones(1)).toString()).to.equal('6');
  });
  // Test: Obtencion de la Historia del Producto
  // Test: Se crea un nuevo token de un tipo diferente
  it('Se crea un nuevo token de un tipo diferente', async function () {
    const receipt = await this.contract.createProduct(55331, "@19.4687249,-99.1345574,15z", "ABC", { from: other });
    expectEvent(receipt, 'VerduraCreada', { _PLUCode: "55331", _creacionAddress: other});
  });
  // Test: Validar numero total de Tokens
  it('Validar numero total de Tokens', async function () {
    expect((await this.contract.totalSupply()).toString()).to.equal('2');
  });
  // Test: Validar que el dueño del Token 2 sea other
  it('Validar que el dueño del Token 2 sea other', async function () {
    expect((await this.contract.ownerOf(2))).to.equal(other);
  });
  // Cambiar el Enviar Token para que en ese momento se haga la actualizacion de la Accion
  // Agregar un Metodo que traiga toda la historia
});