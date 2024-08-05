import { Sequelize } from 'sequelize-typescript';
import { config } from './config/config';

console.log('Initializing database connection...');
console.log(`Host: ${config.host}`);
console.log(`Database: ${config.database}`);
console.log(`Username: ${config.username}`);

export const sequelize = new Sequelize({
  username: config.username,
  password: config.password,
  database: config.database,
  host: config.host,
  dialect: 'postgres',
  port: 5432,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
  logging: console.log, // Enable logging to see the SQL queries
});
