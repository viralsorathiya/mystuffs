
**Standard Practices**:
- Use appropriate protocols (e.g., SNMP, SSH, WMI, HTTP) for telemetry collection
- Implement custom scripts or plugins for non-standard applications
- Use synthetic transactions for critical workflows and user journeys

**Naming Convention**: `[Environment]-[Platform]-[Service]-[Component]`

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

---

## 4. Service Level Objectives (SLOs)

### 4.1 SLO Definition Requirements
All critical services must define:
- **Availability SLO**: % uptime over a rolling 30-day window
- **Latency SLO**: P95/P99 response time targets
- **Error Rate SLO**: Acceptable failure rate over time

### 4.2 SLO Tiers

| Tier | Availability | Latency (P95) | Error Rate |
|------|--------------|----------------|-------------|
| Tier 1 (Critical) | 99.9% | < 200ms | < 0.1% |
| Tier 2 (Important) | 99.5% | < 500ms | < 0.5% |
| Tier 3 (Standard) | 99.0% | < 1000ms | < 1.0% |

### 4.3 Error Budget Management
- Track error budget weekly
- Deploy freeze if 50% consumed
- Postmortem required if fully consumed

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

---

## 7. Data Management

### 7.1 Retention Policies

| Data Type | Retention |
|-----------|-----------|
| Raw metrics | 30 days |
| Hourly aggregates | 6 months |
| Daily aggregates | 2 years |
| Logs | 30 days |
| Session/user data | 35 days |

### 7.2 Metric Naming Standards
Use consistent prefixes:
- `app.` = Application metrics
- `infra.` = Infra-level metrics
- `business.` = Business KPIs
- `sli.` = Service Level Indicators

---

## 8. Access Control and Security

### 8.1 Role-Based Access
- **SRE**: Full access to config, alerting, dashboards
- **Developers**: Read-only to dashboards and metrics
- **Management**: View access to SLO dashboards
- **On-call**: Alert visibility and ack permissions

### 8.2 Security Requirements
- MFA enabled on all monitoring tools
- API key rotation every 90 days
- Audit logging for changes
- IP/network restrictions where possible

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

## 10. Maintenance and Review

### 10.1 Review Schedule
- **Weekly**: Alert review & noise reduction
- **Monthly**: SLO error budget analysis
- **Quarterly**: Coverage audit
- **Annually**: Tooling & standards update

### 10.2 Configuration Management
- Store configs in version control (Git)
- Peer review before production alert changes
- Rollback plan for any config changes

### 10.3 Continuous Improvement
- Solicit feedback from dev and ops teams
- Track monitoring tool performance
- Test and onboard new observability features

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
