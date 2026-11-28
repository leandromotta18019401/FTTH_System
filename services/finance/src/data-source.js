"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppDataSource = void 0;
require("dotenv/config");
var typeorm_1 = require("typeorm");
var invoice_entity_1 = require("./entities/invoice.entity");
var payment_entity_1 = require("./entities/payment.entity");
var fiscal_rule_entity_1 = require("./entities/fiscal_rule.entity");
exports.AppDataSource = new typeorm_1.DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 5432,
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'ftth_finance',
    synchronize: false,
    logging: false,
    entities: [invoice_entity_1.Invoice, payment_entity_1.Payment, fiscal_rule_entity_1.FiscalRule],
    migrations: [
        __dirname + '/migration/*.ts',
    ],
});
exports.default = exports.AppDataSource;
//# sourceMappingURL=data-source.js.map