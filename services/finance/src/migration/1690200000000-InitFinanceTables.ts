/*
 TypeORM migration to create initial finance tables.
 Run with: npx typeorm migration:run -d src/data-source.ts
*/
import { MigrationInterface, QueryRunner } from "typeorm";

export class InitFinanceTables1690200000000 implements MigrationInterface {
  name = "InitFinanceTables1690200000000";

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "invoice" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "clientId" character varying(100) NOT NULL,
        "amount" numeric(12,2) NOT NULL,
        "status" character varying(20) NOT NULL,
        "fiscalData" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_invoice_id" PRIMARY KEY ("id")
      );
    `);
    await queryRunner.query(`
      CREATE TABLE "payment" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "invoiceId" uuid NOT NULL,
        "method" character varying(20) NOT NULL,
        "amount" numeric(12,2) NOT NULL,
        "status" character varying(20) NOT NULL,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_payment_id" PRIMARY KEY ("id"),
        CONSTRAINT "FK_payment_invoice" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE CASCADE
      );
    `);
    await queryRunner.query(`
      CREATE TABLE "fiscal_rule" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "name" character varying(100) NOT NULL,
        "rule" jsonb NOT NULL,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_fiscal_rule_id" PRIMARY KEY ("id")
      );
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "payment"`);
    await queryRunner.query(`DROP TABLE "invoice"`);
    await queryRunner.query(`DROP TABLE "fiscal_rule"`);
  }
}

