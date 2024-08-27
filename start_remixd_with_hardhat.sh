#!/bin/bash

# Define the processes to run
PROCESSES=(
    "remixd -s ./ --remix-ide https://remix.ethereum.org"
    "firefox https://remix.ethereum.org"
    "npx hardhat node"
)

# File to store PIDs
PID_FILE="process_ids.txt"

# Function to start processes
start_processes() {
    echo "Starting processes..."

    for process in "${PROCESSES[@]}"; do
        nohup $process > "${process%% *}.log" 2>&1 &
        echo $! >> $PID_FILE
    done

    echo "Processes started with PIDs:"
    cat $PID_FILE
}

# Function to kill processes
kill_processes() {
    echo "Initiating shutdown of processes..."

    if [ -f "$PID_FILE" ]; then
        while read -r pid; do
            if ps -p $pid > /dev/null; then
                kill $pid
                echo "Sent SIGTERM to process with PID: $pid"
                
                # Wait for a short period to allow the process to terminate gracefully
                sleep 3
                
                # Check if the process is still running
                if ps -p $pid > /dev/null; then
                    echo "Process with PID $pid did not terminate. Sending SIGKILL..."
                    kill -9 $pid  # Force kill if it didn't shut down gracefully
                else
                    echo "Process with PID $pid terminated gracefully."
                fi
            else
                echo "Process with PID $pid is not running."
            fi
        done < "$PID_FILE"
        rm -f "$PID_FILE"
        rm -f *.log
    else
        echo "No PID file found."
    fi
}

# Main script logic
case "$1" in
    start)
        start_processes
        ;;
    stop)
        kill_processes
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac