### Tremendous Embed Rails Sample App

This is a sample implementation of the Tremendous Embed module within a Rails application.

### Getting Started

First, to receive your sandbox API keys, sign up through the [Tremendous sandbox](https://www.tremendous.com/rewards/).

### Configuration

Add an .env file within this project's root with the follow envvars:

```
TREMENDOUS_REST_API_HOST=https://testflight.tremendous.com/api/v2/
TREMENDOUS_API_PRIVATE_KEY=YOUR_SANDBOX_API_PRIVATE_KEY
TREMENDOUS_EMBED_PUBLIC_KEY=YOUR_EMBED_SANDBOX_PUBLIC_KEY
```

### Build

```
bundle
rake db:migrate
rake catalog_update
```

### Run Server

`rails s`


### Getting Started

The heart of the integration is located in a combination of `rewards_controller.rb` and the associated rewards views.

At a high level, the backend encrypts your reward order JSON using your private API keys.  That encrypted JSON  is passed to the embed client SDK as a [JWT](https://jwt.io/) to create a reward via the frontend SDK (see `new.html.erb` for an example).  The reward must then be passed to your backend and approved via the REST API.

### Additional Documentation

The embed SDK documentation can be found [here](https://github.com/GiftRocket/tremendous-embed). The REST documentation can be found [here](https://www.tremendous.com/docs).

