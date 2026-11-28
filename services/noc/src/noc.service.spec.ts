import { NocService } from './noc.service';

describe('NocService', () => {
  let service: NocService;

  beforeEach(() => {
    service = new NocService();
  });

  it('deve retornar o status online do serviço NOC', () => {
    expect(service.getStatus()).toEqual({
      status: 'online',
      service: 'NOC',
    });
  });
});
