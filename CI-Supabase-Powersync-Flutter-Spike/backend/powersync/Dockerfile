FROM journeyapps/powersync-service:latest

# Copy configuration
COPY powersync.yaml /etc/powersync/powersync.yaml

# Set environment variable for config path
ENV POWERSYNC_CONFIG_PATH=/etc/powersync/powersync.yaml

# Expose PowerSync port
EXPOSE 8080

# Command to run the service
CMD ["start", "-r", "unified"]
