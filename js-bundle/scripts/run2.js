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
        console.log('test');
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

//Test
// getEthAddress('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860').then(e =>
//   console.log(e)
// );

// getMyCampaigns('0xF11f935Fe2019541251ed93fC52EAF161a037542').then(res => console.log(res));
// getAllCampaigns().then(res => console.log(res));
// getCampaignInfo('0x866c33c7d2866A42403E82EbE00826135f86a3a2').then(res => console.log(res));
// getAllContributors('0xEBE288cF3Cdd6b7f2868DeA0c0cb7a881077149c').then(res => console.log(res));
// getContribution(
//   '0xEBE288cF3Cdd6b7f2868DeA0c0cb7a881077149c',
//   '0x3aea49553Ce2E478f1c0c5ACC304a84F5F4d1f98'
// ).then(res => console.log(res));

// createCampaign(
//   '1000000',
//   '1000000000000',
//   '20',
//   '0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860'
// )
//   .then(res => console.log(res))
//   .catch(e => console.log(e));

// contribute(
//   '01F903CE0C960FF3A9E68E80FF5FFC344358D80CE1C221C3F9711AF07F83A3BD',
//   '0xC3548389d345e88FE54839Ba69c4E097DC3623ae',
//   1000
// )
//   .then(res => console.log(res))
//   .catch(e => console.log(e));

//Test refund

// createCampaign(
//   '1000000',
//   '1000000000000',
//   '20',
//   '0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860'
// )
//   .then(res => console.log(res))
//   .catch(e => console.log(e));

// contribute(
//   '0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860',
//   '0x866c33c7d2866A42403E82EbE00826135f86a3a2',
//   1000
// );

// refund('01F903CE0C960FF3A9E68E80FF5FFC344358D80CE1C221C3F9711AF07F83A3BD')
//   .then(res => console.log(res))
//   .catch(e => console.log(e));

// getContributedCampaigns('0xF11f935Fe2019541251ed93fC52EAF161a037542').then(res => console.log(res));

// getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a')
//   .then(res => console.log(res))
//   .catch(e => console.log(e));
//getEthAddress('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860').then(res=>console.log(res));


// transferOne('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860', '0xdfbcbf075c42cf5e829454652780368a6ec920ed', 1.1)
// .then( res => {
//   console.log(res);
//   getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a').then(
//     res => {
//       console.log(res);
//       getBalance('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860').then(
//         res => console.log(res));
//     }
//   );
// });

// transferOne('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a', '0xF11f935Fe2019541251ed93fC52EAF161a037542', 2.6)
// .then( res => {
//   console.log(res);
//   getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a').then(
//     res => {
//       console.log(res);
//       getBalance('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860').then(
//         res => console.log(res));
//     }
//   );
// });

(async function(){

// info = await getCampaignInfo('0x243407D25D81aD5D67f2AAFf09Ae7f707116f38B');
// console.log(info);


// balance = await getBalance('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860');
// console.log(balance);
// balance = await getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a');
// console.log(balance);

// await transferOne('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a', '0xF11f935Fe2019541251ed93fC52EAF161a037542', 2.1);
// await new Promise(r => setTimeout(r, 15000));
// await transferOne('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860', '0xdfbcbf075c42cf5e829454652780368a6ec920ed', 3.1);


// await new Promise(r => setTimeout(r, 15000));
// balance = await getBalance('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860');
// console.log(balance);
// balance = await getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a');
// console.log(balance);
//await createCampaign(1*10**18, '1601462355000', 10000, '0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a');

campaigns = await getAllCampaigns();
console.log(campaigns);
campaigns = await getMyCampaigns('0xdfbcbf075c42cf5e829454652780368a6ec920ed');
console.log(campaigns);
info = await getCampaignInfo('0x243407D25D81aD5D67f2AAFf09Ae7f707116f38B');
console.log(info);
info = await getCampaignInfo('0x95bE08fD1959cE381e3C3808627d27171d0aA6f9');
console.log(info);
})();

// 0xDfBCBf075c42CF5E829454652780368A6eC920ed