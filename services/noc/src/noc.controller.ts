import { Controller, Get } from '@nestjs/common';
import { NocService } from './noc.service';

@Controller('noc')
export class NocController {
  constructor(private readonly nocService: NocService) {}

  @Get('status')
  getStatus() {
    return this.nocService.getStatus();
  }
}