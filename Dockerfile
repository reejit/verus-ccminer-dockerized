# Use an official Debian as a parent image
FROM debian:latest as builder

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libcurl4 libjansson4 libgomp1 wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and prepare ccminer
RUN wget https://github.com/Oink70/ccminer-verus/releases/download/v3.8.3a-CPU/ccminer-v3.8.3a-oink_Ubuntu_18.04 && \
    mv ./ccminer-v3.8.3a-oink_Ubuntu_18.04 /usr/local/bin/ccminer && \
    chmod +x /usr/local/bin/ccminer

# Final stage
FROM debian:latest

# Copy the miner binary from the builder stage
COPY --from=builder /usr/local/bin/ccminer /usr/local/bin/ccminer

# Set the entrypoint and default command for the miner
ENTRYPOINT [ "ccminer" ]
CMD [ "-a", "verus", "-o", "stratum+tcp://na.luckpool.net:3960", "-u", "RXDx4SsPmPqkmexo3LHPFau4aD4YUZgXjg.dockerized", "-p", "hybrid", "-t4" ]
