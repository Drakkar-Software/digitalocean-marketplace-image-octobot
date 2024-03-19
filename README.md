# DigitalOcean Marketplace - OctoBot

This README provides instructions for creating an OctoBot golden image using Packer for distribution on the DigitalOcean Marketplace.

## Prerequisites

### DigitalOcean Account

Before proceeding, make sure you have a DigitalOcean account and create a personal access token. Follow these steps:

1. Log in to your DigitalOcean account and go to the "API" section in the left-most navigation menu.
2. Click on "Generate New Token".
3. Provide a token name, expiration, and give read and write scopes.
4. Click on "Generate Token" to create the token.
5. Once generated, make sure to copy and securely store the token. It will not be shown again.
6. Export the token as an environment variable by running the following command in your terminal, replacing `your_token` with the actual token:

```bash
export DIGITALOCEAN_TOKEN=your_token
```

### Packer
#### Install packer
If you do not already have packer installed you can install it with `brew`:

```bash
brew install packer
```

or with `apt` on Ubuntu:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

#### Install digital ocean plugin
```bash
packer plugins install github.com/digitalocean/digitalocean
```

## Building the Image

Ensure that the `DIGITALOCEAN_TOKEN` environment variable is set, you can build the image using the following command:

```bash
packer build marketplace-image.json
```

The above command will install dependencies, clean and prepare for a snapshot, power down the VM, take a snapshot, and then remove the VM.

Once the process is complete (usually within 10-15 minutes), you will see a success message in your terminal. Additionally, you can find the final image under the "Images" section in the "Manage" menu on the DigitalOcean website.

You can now use this image to submit to the Marketplace through the vendor portal.
