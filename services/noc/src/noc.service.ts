import { Injectable } from '@nestjs/common';

@Injectable()
export class NocService {
  getStatus() {
    return { status: 'online', service: 'NOC' };
  }
}