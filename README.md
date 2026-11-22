# FTTH Provider System (Separado do STM)

Este repositório contém a implementação **isolada** do provedor de FTTH baseada em IXC, sem dependência direta do aplicativo STM. Toda a arquitetura, serviços e integrações foram projetados para operar de forma autônoma, permitindo deployment independente.

## Estrutura do Projeto

```
FTTH_System/
├─ infra/                # Helm charts, Terraform, CI pipelines
├─ services/
│   ├─ finance/          # Billing, Fiscal, NF‑e/NFC‑e, SPED, Convênio 115
│   ├─ noc/              # PPPoE, CGNAT, OLT drivers, TR‑069 ACS
│   ├─ crm/              # Omnichannel, Sales funnel, Viabilidade
│   ├─ stock/            # Inventário, Comodato, rastreio por MAC/serial
│   ├─ payment/          # Módulo Pix/Boleto (SDK + admin config)
│   └─ bi/               # Dashboards em Metabase / PowerBI embed
├─ apps/
│   ├─ stm_bridge/       # Bridge de integração opcional com STM (se necessário)
│   ├─ mobile-tech/      # App Android/iOS para técnicos de campo
│   └─ opa-suite/        # UI Omnichannel
├─ shared/               # DTOs, utils, auth, logger
└─ docs/                 # OpenAPI specs, arquitetura, runbooks
```

## Como iniciar

1. Clone este repositório em sua máquina local.
2. Instale as dependências (Docker, Kubernetes, Node / Python).
3. Execute `docker compose up -d` ou use os Helm charts em `infra/` para subir o ambiente.
4. Consulte a documentação em `docs/` para detalhes de cada módulo.

---

*Este README está em um diretório independente do STM, permitindo deploy e manutenção separados.*
