const { Harmony } = require('@harmony-js/core');
const { Account } = require('@harmony-js/account');
const { ChainID, ChainType, hexToNumber, Unit } = require('@harmony-js/utils');
const GAS_LIMIT = 7021900;
const GAS_PRICE = 1000000000;

const options = {
  gasLimit: GAS_LIMIT,
  gasPrice: GAS_PRICE
};

const hmy = new Harmony('https://api.s0.t.hmny.io', {
  chainId: ChainID.HmyMainnet,
  chainType: ChainType.Harmony
});

const Factory = require('./CampaignFactory.json');
const Campaign = require('./Campaign.json');
const factoryAddress = Factory.networks[ChainID.HmyMainnet].address;

//Common function
async function createAccount() {
  const account = new Account();
  return account.privateKey;
}

async function getEthAddress(_privateKey) {
  const account = new Account(_privateKey);
  return account.checksumAddress;
}

async function getOneAddress(_privateKey) {
  const account = new Account(_privateKey);
  return account.bech32Address;
}

async function getBalance(_privateKey) {
  const account = Account.add(_privateKey);
  console.log('address', account.address);
  let res = await hmy.blockchain.getBalance({ address: account.address });
  let balance = hexToNumber(res.result) / 10 ** 18;
  return balance;
}

//Factory function

async function getAllCampaigns() {
  const factory = hmy.contracts.createContract(Factory.abi, factoryAddress);
  try {
    let campaigns = await factory.methods.getAllCampaigns().call(options);
    return campaigns;
  } catch (e) {
    return 'error' + e;
  }
}

async function getMyCampaigns(_address) {
  const factory = hmy.contracts.createContract(Factory.abi, factoryAddress);
  try {
    let campaigns = await factory.methods.getMyCampaigns(_address).call(options);
    return campaigns;
  } catch (e) {
    return 'error' + e;
  }
}

async function createCampaign(_fundCall, _timeLock, _minimumContribution, _privateKey) {
  try {
    const factory = hmy.contracts.createContract(Factory.abi, factoryAddress);
    factory.wallet.addByPrivateKey(_privateKey);
    const tx = hmy.transactions.newTx({ to: factoryAddress });
    await factory.wallet.signTransaction(tx);
    await factory.methods
      .createCampaign(_fundCall, _timeLock, _minimumContribution)
      .send(options)
      .then(res => {
        return 'success';
      })
      .catch(e => {
        return 'error' + e;
      });
  } catch (e) {
    return 'error' + e;
  }
}

//Campaign

async function getCampaignInfo(_campaignAddress) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    let owner = await campaign.methods.owner().call(options);
    let fundCall = await campaign.methods.fundCall().call(options);
    let balance = await campaign.methods.currentBalance().call(options);
    let timeLock = await campaign.methods.timeLock().call(options);
    let complete = await campaign.methods.complete().call(options);
    return {
      owner,
      fundCall: parseInt(fundCall),
      balance: parseInt(balance),
      timeLock: parseInt(timeLock),
      complete: complete
    };
  } catch (e) {
    return 'error' + e;
  }
}

async function getAllContributors(_campaignAddress) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    let contributors = await campaign.methods.getAllContributors().call(options);
    return contributors;
  } catch (e) {
    return 'error' + e;
  }
}

async function getContribution(_campaignAddress, _address) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    let contribution = await campaign.methods.contributions(_address).call(options);
    return parseInt(contribution);
  } catch (e) {
    return 'error ' + e;
  }
}

async function getContributedCampaigns(_userAddress) {
  try {
    const factory = hmy.contracts.createContract(Factory.abi, factoryAddress);
    const allCampaigns = await factory.methods.getAllCampaigns().call(options);
    let contributedCampaigns = [];
    if (allCampaigns.length) {
      await Promise.all(
        allCampaigns.map(async function (e) {
          let campaign = hmy.contracts.createContract(Campaign.abi, e);
          let contributors = await campaign.methods.getAllContributors().call(options);
          if (contributors.includes(_userAddress)) {
            contributedCampaigns.push(e);
          }
        })
      );
    }
    return contributedCampaigns;
  } catch (e) {
    return 'error ' + e;
  }
}

async function contribute(_privateKey, _campaignAddress, _amount) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    campaign.wallet.addByPrivateKey(_privateKey);
    const tx = hmy.transactions.newTx({ to: _campaignAddress });
    await campaign.wallet.signTransaction(tx);
    await campaign.methods
      .contribute()
      .send({ ...options, value: _amount })
      .then(res => {
        return 'success';
      })
      .catch(e => {
        return 'error' + e;
      });
  } catch (e) {
    return 'error ' + e;
  }
}

async function refund(_privateKey, _campaignAddress) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    campaign.wallet.addByPrivateKey(_privateKey);
    const tx = hmy.transactions.newTx({ to: _campaignAddress });
    await campaign.wallet.signTransaction(tx);
    await campaign.methods
      .refund()
      .send(options)
      .then(res => {
        return 'success';
      })
      .catch(e => {
        return 'error' + e;
      });
  } catch (e) {
    return 'error ' + e;
  }
}

async function withdraw(_privateKey, _campaignAddress) {
  try {
    const campaign = hmy.contracts.createContract(Campaign.abi, _campaignAddress);
    campaign.wallet.addByPrivateKey(_privateKey);
    const tx = hmy.transactions.newTx({ to: _campaignAddress });
    await campaign.wallet.signTransaction(tx);
    await campaign.methods
      .withdraw()
      .send(options)
      .then(res => {
        return 'success';
      })
      .catch(e => {
        return 'error' + e;
      });
  } catch (e) {
    return 'error ' + e;
  }
}

async function transferOne(_privateKey, _receiver, _amount) {
  try {
    let oneAddressReceiver = hmy.crypto.getAddress(_receiver).bech32;
    hmy.wallet.addByPrivateKey(_privateKey);
    const txn = hmy.transactions.newTx({
      to: oneAddressReceiver,
      value: new Unit(_amount).asOne().toWei(),
      // gas limit, you can use string
      gasLimit: '21000',
      // send token from shardID
      shardID: 0,
      // send token to toShardID
      toShardID: 0,
      // gas Price, you can use Unit class, and use Gwei, then remember to use toWei(), which will be transformed to BN
      gasPrice: new hmy.utils.Unit('1').asGwei().toWei()
    });

    // sign the transaction use wallet;
    const signedTxn = await hmy.wallet.signTransaction(txn);
    const txnHash = await hmy.blockchain.sendTransaction(signedTxn);
    return txnHash;
  } catch (e) {
    return 'error' + e;
  }
}

module.exports = {
  refund: refund,
  contribute: contribute,
  getContribution: getContribution,
  getAllContributors: getAllContributors,
  getCampaignInfo: getCampaignInfo,
  createCampaign: createCampaign,
  getMyCampaigns: getMyCampaigns,
  getAllCampaigns: getAllCampaigns,
  getBalance: getBalance,
  getOneAddress: getOneAddress,
  getEthAddress: getEthAddress,
  createAccount: createAccount,
  getContributedCampaigns: getContributedCampaigns,
  withdraw: withdraw,
  transferOne: transferOne
};
