#!/bin/bash

mountPoint=$1
computerName=$2
username=$3

conf=/private/var/osquery/osquery.conf
flags=/private/var/osquery/osquery.flags
audit=/private/etc/security/audit_control

# Backup everything

if [[ -f "$conf" ]]; then
  mv $conf $conf.old
fi
if [[ -f "$flags" ]]; then
  mv $flags $flags.old
fi
if [[ -f "$audit" ]]; then
  cp $audit $audit.old
fi

# Populate the OSQuery configuration file

cat > $conf <<EOF
{
  // Configure the daemon below:
  "options": {
    // Select the osquery config plugin.
    "config_plugin": "filesystem",

    // Select the osquery logging plugin.
    "logger_plugin": "filesystem",

    // The log directory stores info, warning, and errors.
    // If the daemon uses the 'filesystem' logging retriever then the log_dir
    // will also contain the query results.
    "logger_path": "/var/log/osquery",

    // Set 'disable_logging' to true to prevent writing any info, warning, error
    // logs. If a logging plugin is selected it will still write query results.
    //"disable_logging": "false",

    // Splay the scheduled interval for queries.
    // This is very helpful to prevent system performance impact when scheduling
    // large numbers of queries that run a smaller or similar intervals.
    //"schedule_splay_percent": "10",

    // A filesystem path for disk-based backing storage used for events and
    // query results differentials. See also 'use_in_memory_database'.
    //"database_path": "/var/osquery/osquery.db",

    // Comma-delimited list of table names to be disabled.
    // This allows osquery to be launched without certain tables.
    //"disable_tables": "foo_bar,time",

   // add tls remote logger
   "config_plugin": "tls",

   "worker_threads": "2",
   "enable_monitor": "true",
   "disable_events": "false",
   "host_identifier": "TEMPHOST",

    "utc": "true"
  },

  // Define a schedule of queries:
  "schedule": {
    // This is a simple example query that outputs basic system information.
    "system_info": {
      // The exact query to run.
      "query": "SELECT hostname, cpu_brand, physical_memory FROM system_info;",
      // The interval in seconds to run this query, not an exact interval.
      "interval": 3600
    }
  },

  // Decorators are normal queries that append data to every query.
  "decorators": {
    "load": [
      "SELECT uuid AS host_uuid FROM system_info;",
      "SELECT user AS username FROM logged_in_users ORDER BY time DESC LIMIT 1;"
    ]
  },

  // Add default osquery packs or install your own.
  //
  // There are several 'default' packs installed with 'make install' or via
  // packages and/or Homebrew.
  //
  // Linux:        /usr/share/osquery/packs
  // OS X:         /var/osquery/packs
  // Homebrew:     /usr/local/share/osquery/packs
  // make install: {PREFIX}/share/osquery/packs
  //
  "packs": {
     "osquery-monitoring": "/var//osquery/packs/osquery-monitoring.conf",
     "incident-response": "/var/osquery/packs/incident-response.conf",
     "it-compliance": "/var/osquery/packs/it-compliance.conf",
     "osx-attacks": "/var/osquery/packs/osx-attacks.conf",
     "vuln-management": "/var/osquery/packs/vuln-management.conf",
     "hardware-monitoring": "/var/osquery/packs/hardware-monitoring.conf",
     "ossec-rootkit": "/var/osquery/packs/ossec-rootkit.conf"
    // "windows-hardening": "C:\\ProgramData\\osquery\\packs\\windows-hardening.conf",
    // "windows-attacks": "C:\\ProgramData\\osquery\\packs\\windows-attacks.conf"
  },

  // Provides feature vectors for osquery to leverage in simple statistical
  // analysis of results data.
  //
  // Currently this configuration is only used by Windows in the Powershell
  // Events table, wherein character_frequencies is a list of doubles
  // representing the aggregate occurence of character values in Powershell
  // Scripts. A default configuration is provided which was adapated from
  // Lee Holmes cobbr project:
  // https://gist.github.com/cobbr/acbe5cc7a186726d4e309070187beee6
  //
  "feature_vectors": {
    "character_frequencies": [
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.00045,  0.01798,
      0.0,      0.03111,  0.00063,  0.00027,   0.0,      0.01336,  0.0133,
      0.00128,  0.0027,   0.00655,  0.01932,   0.01917,  0.00432,  0.0045,
      0.00316,  0.00245,  0.00133,  0.001029,  0.00114,  0.000869, 0.00067,
      0.000759, 0.00061,  0.00483,  0.0023,    0.00185,  0.01342,  0.00196,
      0.00035,  0.00092,  0.027875, 0.007465,  0.016265, 0.013995, 0.0490895,
      0.00848,  0.00771,  0.00737,  0.025615,  0.001725, 0.002265, 0.017875,
      0.016005, 0.02533,  0.025295, 0.014375,  0.00109,  0.02732,  0.02658,
      0.037355, 0.011575, 0.00451,  0.005865,  0.003255, 0.005965, 0.00077,
      0.00621,  0.00222,  0.0062,   0.0,       0.00538,  0.00122,  0.027875,
      0.007465, 0.016265, 0.013995, 0.0490895, 0.00848,  0.00771,  0.00737,
      0.025615, 0.001725, 0.002265, 0.017875,  0.016005, 0.02533,  0.025295,
      0.014375, 0.00109,  0.02732,  0.02658,   0.037355, 0.011575, 0.00451,
      0.005865, 0.003255, 0.005965, 0.00077,   0.00771,  0.002379, 0.00766,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0,      0.0,       0.0,      0.0,      0.0,
      0.0,      0.0,      0.0
    ]
  }
}
EOF

# Populate the OSQuery flag file

cat > $flags <<EOF
--enroll_secret_path=/var/osquery/enroll_secret
--tls_server_certs=/var/osquery/certs/172.31.40.172_8080.pem
--tls_hostname=172.31.40.172:8080
--host_identifier=TEMPHOST
--enroll_tls_endpoint=/api/v1/osquery/enroll
--config_plugin=tls
--config_tls_endpoint=/api/v1/osquery/config
--config_tls_refresh=10
--disable_distributed=false
--distributed_plugin=tls
--distributed_interval=3
--distributed_tls_max_attempts=3
--distributed_tls_read_endpoint=/api/v1/osquery/distributed/read
--distributed_tls_write_endpoint=/api/v1/osquery/distributed/write
--logger_plugin=tls
--logger_tls_endpoint=/api/v1/osquery/log
--logger_tls_period=10
--disable_events=false
--disable_audit=false
--docker_socket=/var/run/docker.sock
EOF

# Configure the audit service

sed -i '' "s/flags\:lo\,aa/flags\:lo\,pc\,ex\,aa\,ap/g" $audit

# Edit the text files to inject the local hostname

sed -i '' "s/TEMPHOST/$computerName/g" $conf
sed -i '' "s/TEMPHOST/$computerName/g" $flags

# Restart the Audit subsystem
audit -s

# Start the osquery service
/usr/local/bin/osqueryctl start