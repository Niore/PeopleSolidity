const People = artifacts.require("People");
const truffleAssert = require("truffle-assertions");

contract("People", async (accounts) => {
  let instance;

  before(async () => {
    instance = await People.deployed();
  });

  it("should not create a person with age over 150 years", async () => {
    await truffleAssert.fails(instance.createPerson("Julian", 200, 186, { value: web3.utils.toWei("1", "ether") }), truffleAssert.ErrorType.REVERT);
  });

  it("should not create a person without payment", async () => {
    await truffleAssert.fails(instance.createPerson("Julian", 28, 186, { value: 1000 }), truffleAssert.ErrorType.REVERT);
  });

  it("should check Person infos", async () => {
    await instance.createPerson("Julian", 70, 186, { value: web3.utils.toWei("1", "ether"), from: accounts[0] });
    let person = await instance.getPerson();
    assert(person.senior === true, "Senior level not set");
    assert(person.age.toNumber() === 70, "Age was not correct");
    assert(person.height.toNumber() === 186, "Height was not correct");
  });

  it("should not allow deletePerson", async () => {
    truffleAssert.fails(instance.deletePerson(accounts[0], { from: accounts[1] }), truffleAssert.ErrorType.OUT_OF_GAS);

  });

  it("should allow deletePerson", async () => {
    truffleAssert.passes(instance.deletePerson(accounts[0], { from: accounts[0] }));
  });
});