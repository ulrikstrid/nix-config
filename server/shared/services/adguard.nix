{ config
, pkgs
, lib
, ...
}: {
  services.adguardhome = {
    enable = true;

    mutableSettings = false;
    openFirewall = true;

    settings = {
      bind_host = "0.0.0.0";
      bind_port = 3000;
      beta_bind_port = 0;
      users = [
        {
          name = "ulrik";
          # Password is bcrypted so should be fine
          password = "$2a$10$LfX621lvSpUp17J5ey6OteBn9GdKgc5X2Rxsol1HxIk.ByDbF1uxq";
        }
      ];
      auth_attempts = 5;
      block_auth_min = 15;
      http_proxy = "";
      language = "";
      debug_pprof = false;
      web_session_ttl = 720;
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        statistics_interval = 30;
        querylog_enabled = true;
        querylog_file_enabled = true;
        querylog_interval = "2160h";
        querylog_size_memory = 1000;
        anonymize_client_ip = false;
        protection_enabled = true;
        blocking_mode = "default";
        blocking_ipv4 = "";
        blocking_ipv6 = "";
        blocked_response_ttl = 10;
        parental_block_host = "family-block.dns.adguard.com";
        safebrowsing_block_host = "standard-block.dns.adguard.com";
        ratelimit = 20;
        ratelimit_whitelist = [ ];
        refuse_any = true;
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.cloudflare.com/dns-query"
        ];
        upstream_dns_file = "";
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        all_servers = false;
        fastest_addr = false;
        fastest_timeout = "1s";
        allowed_clients = [ ];
        disallowed_clients = [ ];
        blocked_hosts = [ "version.bind" "id.server" "hostname.bind" ];
        trusted_proxies = [ "127.0.0.0/8" "::1/128" ];
        cache_size = 4194304;
        cache_ttl_min = 0;
        cache_ttl_max = 0;
        cache_optimistic = false;
        bogus_nxdomain = [ ];
        aaaa_disabled = false;
        enable_dnssec = false;
        edns_client_subnet = false;
        max_goroutines = 300;
        ipset = [ ];
        filtering_enabled = false;
        filters_update_interval = 12;
        parental_enabled = false;
        safesearch_enabled = false;
        safebrowsing_enabled = true;
        safebrowsing_cache_size = 1048576;
        safesearch_cache_size = 1048576;
        parental_cache_size = 1048576;
        cache_time = 30;
        rewrites = [ ];
        blocked_services = [ ];
        upstream_timeout = "10s";
        local_domain_name = "lan";
        resolve_clients = true;
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [ ];
      };
      tls = {
        enabled = false;
        server_name = "";
        force_https = false;
        port_https = 443;
        port_dns_over_tls = 853;
        port_dns_over_quic = 784;
        port_dnscrypt = 0;
        dnscrypt_config_file = "";
        allow_unencrypted_doh = false;
        strict_sni_check = false;
        certificate_chain = "";
        private_key = "";
        certificate_path = "";
        private_key_path = "";
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = false;
          url = "https://adaway.org/hosts.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          enabled = false;
          url = "https://www.malwaredomainlist.com/hostslist/hosts.txt";
          name = "MalwareDomainList.com Hosts List";
          id = 4;
        }
      ];
      whitelist_filters = [ ];
      user_rules = [ "@@||prod.msocdn.com^" "@@||api.smartthings.com^" "@@||l2.io^" ];
      dhcp = {
        enabled = false;
        interface_name = "";
        dhcpv4 = {
          gateway_ip = "";
          subnet_mask = "";
          range_start = "";
          range_end = "";
          lease_duration = 86400;
          icmp_timeout_msec = 1000;
          options = [ ];
        };
        dhcpv6 = {
          range_start = "";
          lease_duration = 86400;
          ra_slaac_only = false;
          ra_allow_slaac = false;
        };
      };
      clients = [
        {
          name = "Laptop Legion";
          tags = [ "device_laptop" "os_windows" ];
          ids = [ "192.168.1.225" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = true;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = true;
          use_global_blocked_services = true;
        }
        {
          name = "SG";
          tags = [ "device_other" ];
          ids = [ "192.168.1.1" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = false;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
        {
          name = "Sissels Galaxy S20";
          tags = [ "device_phone" "os_android" ];
          ids = [ "192.168.1.7" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = false;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
        {
          name = "Sissels surface pro";
          tags = [ "device_laptop" "os_windows" ];
          ids = [ "192.168.1.235" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = false;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
        {
          name = "Skrivaren";
          tags = [ "device_printer" ];
          ids = [ "192.168.1.172" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = false;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
        {
          name = "Ulriks S20 ultra";
          tags = [ "device_phone" "os_android" ];
          ids = [ "192.168.1.185" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = false;
          filtering_enabled = false;
          parental_enabled = true;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
        {
          name = "servern";
          tags = [ "os_linux" ];
          ids = [ "192.168.1.101" ];
          blocked_services = [ ];
          upstreams = [ ];
          use_global_settings = true;
          filtering_enabled = false;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
          use_global_blocked_services = true;
        }
      ];
      log_compress = false;
      log_localtime = false;
      log_max_backups = 0;
      log_max_size = 100;
      log_max_age = 3;
      log_file = "";
      verbose = false;
      os = {
        group = "";
        user = "";
        rlimit_nofile = 0;
      };
      schema_version = 12;
    };
  };

  networking.firewall.allowedTCPPorts = [
    53 # dns
  ];

  networking.firewall.allowedUDPPorts = [
    53 # dns
  ];
}
