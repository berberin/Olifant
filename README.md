# Olifant

Olifant is a crowdfunding app for mobile devices. On Harmony.

## Inspiration

Inspired by crowdfunding apps such as Kickstarter and Indiegogo, we have built a crowdfunding app, Olifant, with Blockchain Harmony technology, which allows investors to directly donate cryptocurrency to crowdsoured projects. Olifant is built for mobile devices and currently supports ONE as its main currency.

The simplicity of donating via an in-app wallet makes Olifant highly accessible for all potential investors while the fact that it is completely free makes the app irresistible for all potential crowdsourcers. Yes, unlike many other crowdfunding apps, we do not charge a 5% fee per donation. Olifant is built with Smart Contracts and serverless solutions, which allow it to operate without users' monetary contributions.

So, take a deep breath, pick up this Olifant, and make your project known to the world!



## Getting Started

We built Olifant with 2 main components: Smart contract written by Solidity and deployed to mainnet, and Interface written by Flutter.

1. Smart Contract: There are 2 main parts for Smart Contract: Factory and Campaign. Each project is an instance of Campaign while the management of each crowdsoure campaign is handled by Factory contract. All financial data is processed via these Contracts.contract campaign is responsible for managing all the logic of the crowdfunding campaign. The Crowdsourcers can only withdraw money from the smart contract when all conditions are met. Investors can also withdraw their money when the fundraising campaign fails.

2. Flutter: We interact with Smart Contracts via JS-wrapper functions. We store project updates and comments by users in Firebase Firestore.

This project is a starting point for a Flutter application.

At the moment we have released an .apk file for Android. For iOS, you can build the app from the source code. Google Play Beta & AppStore coming soon.



To rebuild auto-generated code:

```
flutter pub run build_runner build
```

The file google-services.json in android/app/src and ios/Runner are connected to a Firebase application that we only use for development. Please replace it with google-services.json from your firebase app.

A few resources to get you started:

- [(Flutter) Build and release an iOS app](https://flutter.dev/docs/deployment/ios)
- [Video demo](https://youtu.be/bed2pQpXq4I)

For help getting started with Flutter, view Flutter's [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.