# SRE Monitoring Standards

## Purpose
This document defines standardized monitoring practices, configurations, and procedures for our SRE team to ensure consistent observability across all systems and environments.

---

## 1. Monitoring Coverage Standards

### 1.1 Required Monitoring for All Systems
Every system in production must have:
- **Health checks**: Endpoint monitoring with <30s check intervals
- **Resource monitoring**: CPU, memory, disk, network utilization
- **Error rate tracking**: Application and system-level errors
- **Performance metrics**: Response times and throughput
- **Availability monitoring**: Uptime tracking with 99.x% targets

### 1.2 Platform-Specific Requirements

#### Kubernetes Clusters
- Node resource utilization (CPU, memory, disk)
- Pod restart counts and failure reasons
- Cluster events and API server health
- Ingress controller performance
- Persistent volume usage and performance

#### Mainframe Systems
- Job completion status and execution times
- System resource consumption
- Transaction response times (CICS/IMS)
- Database performance metrics
- Batch window adherence

#### Applications (All Platforms)
- Request/response metrics (rate, errors, duration)
- Database connection pool status
- External dependency health
- Business logic metrics
- User experience metrics

---

## 3. Alerting Standards

### 3.1 Alert Severity Levels
- **Critical (P1)**: Service down, revenue impact, immediate response required
- **High (P2)**: Degraded performance, user impact, 15min response SLA
- **Medium (P3)**: Potential issues, business hours response
- **Low (P4)**: Informational, no immediate action needed

### 3.2 Alert Naming Convention
Format: `[Severity] [Service] [Component] [Metric] [Condition]`

**Examples:**
- `CRITICAL WebApp Database Connection Pool Exhausted`
- `HIGH OrderService API Response Time Above Threshold`
- `MEDIUM K8S Node CPU Utilization High`

### 3.3 Alert Requirements
Every alert must include:
- Clear description of the problem
- Impact assessment (user/business)
- Initial troubleshooting steps
- Escalation path and contacts
- Links to relevant dashboards/runbooks

### 3.4 Alert Thresholds

**Infrastructure:**
- CPU: Warning 80%, Critical 95%
- Memory: Warning 85%, Critical 95%
- Disk: Warning 80%, Critical 90%
- Network: Warning 80% bandwidth, Critical 95%

**Applications:**
- Response time: Warning P95 > SLO, Critical P95 > 2x SLO  
- Error rate: Warning > 1%, Critical > 5%  
- Availability: Critical < 99% over 5min window

> ⚠️ **Note:** These thresholds serve as global baseline standards. Teams are encouraged to tune alert thresholds based on:
> - **Environment context** (e.g., production vs. staging vs. dev)
> - **System role** (e.g., API gateway vs. background job worker vs. database)
> - **Workload patterns** (e.g., batch, streaming, high-frequency transactions)
>
> **Examples:**
> - 90% CPU may be fine for compute-heavy cache layers like Redis but not for latency-sensitive APIs.
> - Disk spikes may occur during scheduled backups—monitor for sustained usage over time, not momentary peaks.
> - An authentication service or Traffix interface may require more aggressive error rate monitoring than an internal metrics sync job.
>
> **SRE Best Practice:** Every alert threshold should be reviewed during onboarding and refined post-incident to reduce noise and improve signal fidelity. All deviations from standard must be documented in alert definitions or service runbooks.

---

## 4. Service Level Objectives (SLOs)

### 4.1 SLO Definition Requirements
All critical services must define:
- **Availability SLO**: % uptime over a rolling 30-day window
- **Latency SLO**: P95/P99 response time targets
- **Error Rate SLO**: Acceptable failure rate over time

## 4.2 SLO Tiers

| Tier | Availability | Latency (P95) | Error Rate |
|------|--------------|----------------|-------------|
| Tier 1 (Critical) | 99.9% | < 200ms | < 0.1% |
| Tier 2 (Important) | 99.5% | < 500ms | < 0.5% |
| Tier 3 (Standard) | 99.0% | < 1000ms | < 1.0% |

> 🔍 **Note:** These tiers provide a baseline reference. Individual services should define their own SLOs based on user impact, business importance, and historical performance. Critical transactional systems (e.g., authentication, payments, data feeds) should aim for Tier 1 targets. Less critical or asynchronous services may fall into Tier 2 or Tier 3.

---

## 5. Dashboard Standards

### 5.1 Dashboard Hierarchy
1. **SRE Overview**: Cross-platform health summary
2. **Platform Dashboards**: Kubernetes, Mainframe, Infrastructure
3. **Service Dashboards**: App-specific performance & errors
4. **Incident Dashboards**: Troubleshooting & drill-down

### 5.2 Dashboard Requirements
- 4-hour default time range
- Red/Yellow/Green indicators
- SLO compliance graphs
- Link to related dashboards and docs
- Mobile-friendly layouts

### 5.3 Naming Convention
Format: `[Type] - [Scope] - [Detail]`

**Examples:**
- `SRE - Prod - Overview`
- `Platform - Kubernetes - Cluster Health`
- `Service - PaymentAPI - Response Time`

---

## 6. Incident Response Integration

### 6.1 On-Call Procedures
- Primary alerted for P1/P2 immediately
- Secondary alerted if P1 unresolved in 15 mins
- Management escalation after 1hr for P1

### 6.2 Incident Documentation
Capture during incidents:
- Timeline from monitoring tools
- Affected systems/services
- Remediation actions
- Monitoring blind spots

### 6.3 Post-Incident Actions
- Analyze alert timing & gaps
- Update dashboards
- Adjust alert thresholds as needed

### 6.4 Postmortems

All P1 and significant P2 incidents must have a documented postmortem within 5 business days.

#### Requirements:
- **Blameless** tone and fact-based analysis
- **Incident summary**: what happened, when, and how it was resolved
- **Root cause analysis** (RCA) using 5 Whys or similar method
- **Impact assessment**: users, systems, SLAs affected
- **Timeline of events**: detection, escalation, mitigation
- **Corrective actions**: technical, process, or people-based
- **Follow-up tasks** tracked in ticketing/project system
- **Review meeting** with involved teams (optional but encouraged)

---

## 9. Documentation Requirements

### 9.1 Service Onboarding Checklist
Every new service must provide:
- Architecture and business context
- Custom metrics and monitoring needs
- SLO definitions and justification
- On-call contact details
- Runbook(s) for key alerts

### 9.2 Runbook Standards
Each runbook must include:
- Overview and dependencies
- Failure symptoms and recovery steps
- Escalation contacts
- Linked dashboards
- Troubleshooting decision tree

---

## 11. Implementation Checklist

### For New Services:
- [ ] Monitoring requirements defined
- [ ] SLOs approved
- [ ] Instrumentation implemented
- [ ] Dashboards validated
- [ ] Alerts configured and tested
- [ ] Runbooks written
- [ ] On-call plan established

### For Existing Services:
- [ ] Monitoring audited against standards
- [ ] Gaps identified and addressed
- [ ] Migration plans documented
- [ ] Compliance verified
- [ ] Team trained on updates

---

**Document Owner**: SRE Team  
**Last Updated**: _[Date]_  
**Next Review**: _[Date + 3 months]_  
**Approval**: _[Manager Name]_

For questions or feedback, please contact the SRE team or open a ticket in your internal tracking system.
