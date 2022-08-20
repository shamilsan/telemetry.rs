# telemetry.rs

[![Deploy][deploy_badge]][deploy_href]

[deploy_badge]: https://github.com/shamilsan/telemetry.rs/workflows/Deploy/badge.svg
[deploy_href]: https://github.com/shamilsan/telemetry.rs/actions/workflows/deploy.yml

Telemetry site for Substrate-based blockchains.

Source code: https://github.com/paritytech/substrate-telemetry

📺 https://telemetry.rs

## Usage

1. Run your node with `--telemetry-url "wss://telemetry.rs/submit 0"` parameter. For example when running the [Gear node](https://github.com/gear-tech/gear):

    ```
    gear-node --name "node-in-telemetry" --telemetry-url "wss://telemetry.rs/submit 0"
    ```

2. Open https://telemetry.rs and find your node by name (`node-in-telemetry` in the example above). Use the name filter by typing the node's name if necessary.

## Building locally

### Prerequisites

- Rust
- Node.js
- Yarn
- (optional) Ansible

### Commands

- Build both backend and frontend:

      make

- Install on the Ubuntu server using Ansible:

      make install

- Serve locally:

      make -j3 serve

## License

[Substrate telemetry service](https://github.com/paritytech/substrate-telemetry) is distributed under the terms of the [GPL-3.0 license](https://github.com/paritytech/substrate-telemetry/blob/master/LICENSE).
