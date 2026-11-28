import { Injectable } from '@nestjs/common';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class BandwidthService {
  login(dto: LoginDto) {
    return { authenticated: true, user: dto.username };
  }

  getBandwidth() {
    return { downloadMbps: 0, uploadMbps: 0 };
  }
}
