//Test
getEthAddress('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a').then(e =>
  console.log(e)
);

getMyCampaigns('0xDfBCBf075c42CF5E829454652780368A6eC920ed').then(res => console.log(res));
// getAllCampaigns().then(res => console.log(res));
getCampaignInfo('0x12c162Beb0b573CE64c3d2c4f02160269AE506F7').then(res => console.log(res));
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
//   '0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a'
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

// transferOne(
//   '0x0048f9cfe2448f6e6c5fcad84a3be2d8e7680ef8f77bc6179d0e11c87042bc36',
//   'one17y0exhlzqx25zfg7mylu2t40zcdqxa2z63swd2',
//   1
// )
//   .then(res => console.log(res))
//   .catch(e => console.log(e));
// await transferOne('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860', '0xdfbcbf075c42cf5e829454652780368a6ec920ed', 3.1);
// await transferOne('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a', '0xF11f935Fe2019541251ed93fC52EAF161a037542', 2.1);
// await new Promise(r => setTimeout(r, 15000));
// balance = await getBalance('0x220511ee8187dc079c1cc7f922aea67cd2aa38a163a283afd59d0f8f0932b860');
// console.log(balance);
// balance = await getBalance('0xddfa12d534071792c49035d55b9a37a7f50419891437defb1951b47a06a1304a');
// console.log(balance);
// })());
