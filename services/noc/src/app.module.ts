import { Module } from '@nestjs/common';
import { NocController } from './noc.controller';
import { NocService } from './noc.service';

@Module({
  controllers: [NocController],
  providers: [NocService],
})
export class AppModule {}
