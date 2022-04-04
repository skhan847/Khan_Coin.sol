const ClientToken2 = artifacts.require("ClientToken2");

module.exports = function (deployer) {
  deployer.deploy(ClientToken2, 1000);
};
