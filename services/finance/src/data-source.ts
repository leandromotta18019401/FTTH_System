import 'dotenv/config';
import { DataSource } from 'typeorm';
import { Invoice } from './entities/invoice.entity';
import { Payment } from './entities/payment.entity';
import { FiscalRule } from './entities/fiscal_rule.entity';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 5432,
  username: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  database: process.env.DB_NAME || 'ftth_finance',
  synchronize: false,
  logging: false,
  entities: [Invoice, Payment, FiscalRule],
  migrations: [
    __dirname + '/migration/*.ts',
  ],
});

export default AppDataSource;

