{ pkgs, ... }:
{
  services.victoriametrics = {
    enable = true;
    retentionPeriod = "40d";
    listenAddress = "10.255.254.1:8428";
    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "node-exporter";
          metrics_path = "/metrics";
          static_configs = [
            {
              targets = [ "127.0.0.1:9100" ];
              labels.type = "node";
            }
          ];
        }
      ];
    };
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = "127.0.0.1";
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "10.255.254.1";
        http_port = 3000;
        enable_gzip = true;
        enforce_domain = false;
      };

      # Prevents Grafana from phoning home
      analytics.reporting_enabled = false;
    };

    declarativePlugins = [
      pkgs.grafanaPlugins.victoriametrics-metrics-datasource
    ];

    provision = {

      dashboards.settings.providers = [
        {
          name = "Overview";
          options.path = "/etc/grafana-dashboards";
        }
      ];

      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "VictoriaMetrics";
            type = "victoriametrics-metrics-datasource";
            access = "proxy";
            url = "http://10.255.254.1:8428";
            isDefault = true;
          }
        ];
      };
    };
  };
}
