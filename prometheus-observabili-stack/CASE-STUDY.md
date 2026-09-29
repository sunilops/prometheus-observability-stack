# Case Study: Prometheus Observability Stack

## What I Built

A self-hosted monitoring and alerting stack — **Prometheus, Grafana, Alertmanager, and
Node Exporter** — provisioned on AWS with **Terraform** (Infrastructure as Code) and
deployed with **Docker Compose**.

The goal was to build (and be able to rebuild, from scratch, on demand) a complete
observability pipeline: infrastructure provisioning → metrics collection → visualization
→ alert routing, with nothing done by hand in the AWS console.

## Architecture

```
                    ┌───────────────────────────────────────────────┐
                    │                AWS EC2 Instance                │
                    │                                                 │
  scrape (pull)     │   ┌────────────┐        ┌──────────────────┐   │
 ┌──────────────────┼──▶│ Prometheus │──────▶│  Alertmanager     │   │
 │                  │   │   :9090    │ alerts │     :9093         │   │
 │                  │   └─────┬──────┘        └──────────────────┘   │
 │                  │         │ metrics                               │
 │                  │         ▼                                       │
 │                  │   ┌────────────┐                                │
 │                  │   │  Grafana   │  (visualizes Prometheus data)  │
 │                  │   │   :3000    │                                │
 │                  │   └────────────┘                                │
 │                  │                                                 │
 │            ┌──────────────┐                                        │
 └────────────│ Node Exporter│  (exposes host metrics on :9100)       │
              │    :9100     │                                        │
              └──────────────┘                                        │
                    └───────────────────────────────────────────────┘
```

**Provisioning layer (Terraform):**
- Modular structure — separate `ec2` and `security-group` modules composed by a root
  `prometheus-stack` module — so either piece can be reused or swapped independently
- `user-data.sh` bootstraps the instance on first boot: installs Docker + Docker Compose,
  adds 2GB swap (needed since `t3.micro` only ships 1GB RAM and 4 containers together can
  otherwise trigger OOM kills)
- All environment-specific values (region, AMI, VPC, subnet, key pair) isolated into a
  single `.tfvars` file, kept out of the modules themselves

**Runtime layer (Docker Compose):**
- 4 containers on a shared bridge network (`monitor`), so services address each other by
  container name (e.g. Grafana → `http://prometheus:9090`) instead of hardcoded IPs
- Prometheus scrape targets defined via `file_sd_configs` (`targets.json`) rather than
  static config, so targets can be updated without restarting Prometheus
- A `Makefile` patches the EC2 instance's own public IP into the Prometheus config at
  deploy time — the same codebase works on any freshly provisioned instance without manual
  editing

## What It Does

- **Collects**: Node Exporter exposes ~1,000 host-level metrics (CPU, memory, disk,
  network, filesystem) per instance
- **Stores & evaluates**: Prometheus scrapes every 15s, evaluates 4 alert rules
  (`InstanceDown`, `HighCPUUsage`, `HighMemoryUsage`, `HighDiskUsage`) every 15s
- **Visualizes**: Grafana renders the metrics using the community Node Exporter Full
  dashboard (ID 1860) — real-time gauges and time-series graphs
- **Alerts**: firing alerts route from Prometheus to Alertmanager, which groups,
  deduplicates, and (once a receiver is configured) notifies via email or Slack

## Screenshots

> _Add these once captured:_
- [ ] Prometheus **Targets** page showing `node-exporter` as UP
- [ ] Grafana Node Exporter Full dashboard with live data
- [ ] Prometheus **Alerts** page with an alert in `firing` state
- [ ] Alertmanager UI showing the same alert received
- [ ] Terraform `apply` output showing successful resource creation

## Challenges & Fixes

| Issue | Root Cause | Fix |
|---|---|---|
| `subnet_ids` type error | Variable declared as `list(string)`, value passed as a plain string | Wrapped the subnet ID in `[...]` |
| `InvalidVpcID.NotFound` | AWS CLI default region (`us-east-1`) didn't match the region hardcoded in `ec2.tfvars` (`ap-south-1`) — VPC/subnet/AMI IDs are region-specific | Aligned `region` in `.tfvars` with the region actually used to look up the VPC/subnet/AMI |
| `t3.micro` at risk of OOM under 4 containers | Only 1GB RAM on the smallest free-tier-adjacent instance type | Added a 2GB swapfile via `user-data.sh` |

## What I'd Improve Next

- Move Terraform state to a remote backend (S3 + DynamoDB lock table) instead of local
  state, for team use / CI pipelines
- Add TLS termination (e.g. Caddy or an ALB) instead of exposing services on raw HTTP ports
- Configure a real Alertmanager receiver (Slack webhook) instead of the placeholder config
- Add Grafana provisioning-as-code (dashboards + data sources defined in YAML) instead of
  manual UI setup, so the whole stack is reproducible with zero clicks
- Wire this into a CI pipeline (GitHub Actions) that runs `terraform plan` on PRs and
  `terraform apply` on merge to `main`
- Add a `docker-compose` healthcheck + restart policy audit, and persistent volume backups
  for Prometheus TSDB and Grafana dashboards

## Stack

Terraform · AWS (EC2, Security Groups) · Docker · Docker Compose · Prometheus ·
Alertmanager · Grafana · Node Exporter
