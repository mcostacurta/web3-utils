# web3-utils - Ethereum Development Environment Manager 🚀

This bash script helps manage essential processes for Ethereum smart contract development using Remix IDE and Hardhat. It allows you to easily start and stop `remixd`, a local Hardhat node, and automatically open Remix IDE in Firefox.

---
## 📜 Description

The script automates the setup of a local development environment by:

* **Starting processes**:
    * `remixd`: Connects your local filesystem to the Remix IDE, allowing you to work on your smart contracts locally.
    * `firefox https://remix.ethereum.org`: Opens the Remix IDE in the Firefox browser.
    * `npx hardhat node`: Starts a local Hardhat blockchain node for testing and deployment.
    All processes are started in the background (`nohup`), and their standard output and errors are redirected to separate log files (e.g., `remixd.log`, `firefox.log`, `npx.log`). Process IDs (PIDs) are stored in `process_ids.txt`.

* **Stopping processes**:
    * Reads PIDs from `process_ids.txt`.
    * Attempts to gracefully terminate each process using `SIGTERM`.
    * Waits for a short period and checks if the process has terminated.
    * If a process is still running, it sends a `SIGKILL` signal to force its termination.
    * Cleans up by deleting the `process_ids.txt` file and all `.log` files.

---
## 🛠️ Prerequisites

Before running this script, ensure you have the following installed:

* **Bash**: The script is written in Bash and requires a Bash-compatible shell.
* **Node.js & npm/npx**: Required for `npx hardhat node`.
* **Hardhat**: Install globally or have it as a project dependency (`npm install --save-dev hardhat` or `npm install -g hardhat`).
* **remixd**: Install globally (`npm install -g @remix-project/remixd`).
* **Firefox**: The script is configured to open Remix IDE in Firefox. You can change this by modifying the `PROCESSES` array in the script.

---
## 🚀 Usage

1.  **Save the script**: Save the code as a `.sh` file (e.g., `start_remixd_with_hardhat.sh`).
2.  **Make it executable**:
    ```bash
    chmod +x start_remixd_with_hardhat.sh
    ```
3.  **Start the processes**:
    ```bash
    ./start_remixd_with_hardhat.sh start
    ```
    This will start `remixd`, open Remix IDE in Firefox, and launch a Hardhat node. Log files for each process will be created in the same directory, and their PIDs will be stored in `process_ids.txt`.

4.  **Stop the processes**:
    ```bash
    ./start_remixd_with_hardhat.sh stop
    ```
    This will attempt to stop all managed processes and clean up the PID file and log files.

---
## ⚙️ Configuration

### Processes
The `PROCESSES` array at the beginning of the script defines the commands to be executed:

```bash
PROCESSES=(
    "remixd -s ./ --remix-ide [https://remix.ethereum.org](https://remix.ethereum.org)"
    "firefox [https://remix.ethereum.org](https://remix.ethereum.org)"
    "npx hardhat node"
)
