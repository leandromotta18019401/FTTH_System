import { Controller, Post, Body } from '@nestjs/common';
import { BandwidthService } from './bandwidth.service';
import { LoginDto } from './dto/login.dto';

/**
 * Controlador responsável por operações de autenticação e controle de banda.
 * Todos os métodos são apenas stubs e devem ser implementados posteriormente.
 */
@Controller('bandwidth')
export class BandwidthController {
  constructor(private readonly bandwidthService: BandwidthService) {}

  @Post('login')
  login(@Body() dto: LoginDto) {
    // TODO: implementar lógica de login PPPoE/Hotspot
    return this.bandwidthService.login(dto);
  }

  // Outros endpoints (ex: aplicar plano, registrar logs) podem ser adicionados aqui.
}

