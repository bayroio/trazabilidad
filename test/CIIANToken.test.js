// Load dependencies
const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

// Load compiled artifacts
const CIIANToken = contract.fromArtifact('CIIANToken');

// Start test block
describe('CIIANToken', function () {
  const [ owner ] = accounts;

  beforeEach(async function () {
    this.contract = await CIIANToken.new({ from: owner });
  });

  // Test case
  it('Crear un nuevo Token', async function () {
    await this.contract.createProduct(1234, "@19.4687249,-99.1345574,15z", "XWZ");
    expect((await this.contract.getNumeroAcciones(1)).toString()).to.equal('1');
  });
});